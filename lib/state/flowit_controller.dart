import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/device_data.dart';
import '../data/models/history_entry.dart';
import '../data/services/flowit_api_service.dart';
import '../data/services/history_storage_service.dart';
import 'flowit_state.dart';

final flowItApiProvider = Provider<FlowItApiService>((ref) {
  final service = FlowItApiService();
  ref.onDispose(service.dispose);
  return service;
});

final historyStorageProvider = Provider<HistoryStorageService>((ref) {
  return HistoryStorageService();
});

final flowitControllerProvider = StateNotifierProvider<FlowItController, FlowItState>((ref) {
  return FlowItController(ref.read(flowItApiProvider), ref.read(historyStorageProvider));
});

class FlowItController extends StateNotifier<FlowItState> {
  FlowItController(this._api, this._historyStorage) : super(const FlowItState()) {
    unawaited(_bootstrap());
  }

  final FlowItApiService _api;
  final HistoryStorageService _historyStorage;

  Timer? _pollTimer;
  int _failureCount = 0;
  DeviceStatus? _lastStatus;

  DateTime? _activeSessionStart;
  final List<double> _activeSessionFlows = [];
  final List<double> _activeSessionTemps = [];
  bool _activeSessionAligned = true;

  Future<void> _bootstrap() async {
    final baseUrl = await _historyStorage.loadBaseUrl();
    final history = await _historyStorage.loadHistory();

    final hasBaseUrl = (baseUrl ?? '').isNotEmpty;
    state = state.copyWith(
      loading: hasBaseUrl,
      baseUrl: baseUrl ?? state.baseUrl,
      history: history,
      connectionState: hasBaseUrl ? ConnectionStateX.connecting : ConnectionStateX.disconnected,
      clearError: true,
    );

    if (hasBaseUrl) {
      startPolling();
    }
  }

  void startPolling({Duration interval = const Duration(milliseconds: 350)}) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(interval, (_) => unawaited(_pollOnce()));
    unawaited(_pollOnce());
  }

  Future<void> _pollOnce() async {
    try {
      var data = await _api.fetchData(state.baseUrl);
      if (state.devOverrideStatus != null) {
        data = data.copyWith(
          status: state.devOverrideStatus,
          tapOn: state.devOverrideStatus == DeviceStatus.filling,
        );
      }
      _failureCount = 0;

      _handleSession(data);
      _handleAlerts(data);

      final flow = _appendPoint(state.flowPoints, MetricPoint(data.updatedAt, data.flowRate));
      final usage = _appendPoint(state.usagePoints, MetricPoint(data.updatedAt, _normalizeVolumeLiters(data.volume)));
      final temps = _appendPoint(state.temperaturePoints, MetricPoint(data.updatedAt, data.temperature));

      state = state.copyWith(
        loading: false,
        latestData: data,
        flowPoints: flow,
        usagePoints: usage,
        temperaturePoints: temps,
        connectionState: ConnectionStateX.connected,
        clearError: true,
      );

      _lastStatus = data.status;
    } catch (error) {
      _failureCount += 1;
      state = state.copyWith(
        loading: false,
        connectionState: _failureCount >= 5 ? ConnectionStateX.disconnected : ConnectionStateX.reconnecting,
        errorMessage: 'Connection error: Unable to reach device. Check ESP32 IP and WiFi.',
      );
    }
  }

  List<MetricPoint> _appendPoint(List<MetricPoint> source, MetricPoint next) {
    const maxPoints = 180;
    if (source.length >= maxPoints) {
      return [...source.skip(source.length - maxPoints + 1), next];
    }
    return [...source, next];
  }

  void _handleSession(DeviceData data) {
    final previousStatus = _lastStatus;

    if (data.status == DeviceStatus.filling && _activeSessionStart == null) {
      _activeSessionStart = DateTime.now();
      _activeSessionFlows.clear();
      _activeSessionTemps.clear();
      _activeSessionAligned = data.aligned;
    }

    if (_activeSessionStart != null) {
      _activeSessionFlows.add(data.flowRate);
      _activeSessionTemps.add(data.temperature);
      _activeSessionAligned = _activeSessionAligned && data.aligned;
    }

    final hasSessionEnded =
        _activeSessionStart != null && previousStatus == DeviceStatus.filling && data.status != DeviceStatus.filling;

    if (hasSessionEnded) {
      final now = DateTime.now();
      final avgFlow = _activeSessionFlows.isEmpty
          ? 0.0
          : _activeSessionFlows.reduce((a, b) => a + b) / _activeSessionFlows.length;
      final avgTemp = _activeSessionTemps.isEmpty
          ? 0.0
          : _activeSessionTemps.reduce((a, b) => a + b) / _activeSessionTemps.length;

      final entry = SessionEntry(
        startedAt: _activeSessionStart!,
        endedAt: now,
        volumeLiters: _normalizeVolumeLiters(data.volume),
        avgFlowRate: avgFlow,
        avgTemperature: avgTemp,
        aligned: _activeSessionAligned,
      );

      final history = [...state.history, entry];
      state = state.copyWith(history: history);
      unawaited(_historyStorage.saveHistory(history));

      _activeSessionStart = null;
      _activeSessionFlows.clear();
      _activeSessionTemps.clear();
      _activeSessionAligned = true;
    }
  }

  double _normalizeVolumeLiters(double rawVolume) {
    if (rawVolume <= 0) return 0;
    if (rawVolume > 20) return rawVolume / 1000;
    return rawVolume;
  }

  void _handleAlerts(DeviceData data) {
    if (_lastStatus == data.status) return;

    switch (data.status) {
      case DeviceStatus.alignBucket:
        _addAlert('Bucket misaligned. Align container to continue.', AlertType.warning);
        return;
      case DeviceStatus.full:
        _addAlert('Container full. Dispense cycle completed.', AlertType.success);
        return;
      case DeviceStatus.noContainer:
        _addAlert('No container detected. Place a bucket under nozzle.', AlertType.warning);
        return;
      case DeviceStatus.handDetected:
        _addAlert('Hand detected near nozzle. Auto-safety active.', AlertType.info);
        return;
      case DeviceStatus.filling:
        _addAlert('Dispensing started.', AlertType.info);
        return;
      case DeviceStatus.manualMode:
        _addAlert('Manual mode enabled.', AlertType.info);
        return;
      case DeviceStatus.unknown:
        _addAlert('Device status unavailable.', AlertType.warning);
        return;
    }
  }

  void _addAlert(String message, AlertType type) {
    final event = AlertEvent(message: message, type: type, timestamp: DateTime.now());
    final alerts = [event, ...state.alerts];
    state = state.copyWith(alerts: alerts.take(20).toList(growable: false));
  }

  Future<void> setBaseUrl(String value) async {
    final normalized = value.trim().replaceAll(RegExp(r'/+$'), '');
    if (normalized.isEmpty) return;

    state = state.copyWith(baseUrl: normalized, connectionState: ConnectionStateX.connecting, clearError: true);
    await _historyStorage.saveBaseUrl(normalized);
    startPolling();
  }

  void updateParams(FlowItParams params) {
    state = state.copyWith(params: params);
  }

  Future<void> pushParams() async {
    await _performAction(() => _api.setParams(state.baseUrl, state.params.toJson()));
  }

  Future<void> calibrateSensor() async {
    await _performAction(() => _api.calibrate(state.baseUrl));
  }

  Future<void> resetDevice() async {
    await _performAction(() => _api.reset(state.baseUrl));
  }

  Future<void> toggleManualMode() async {
    await _performAction(() => _api.manualToggle(state.baseUrl));
  }

  Future<void> startFlow() async {
    await _performAction(() => _api.startDispense(state.baseUrl));
  }

  Future<void> startVolumeFlow(double targetLiters) async {
    await _performAction(() => _api.startVolumeDispense(state.baseUrl, targetLiters));
  }

  Future<void> stopFlow() async {
    await _performAction(() => _api.stopDispense(state.baseUrl));
  }

  Future<void> setDevOverride(DeviceStatus? status) async {
    state = state.copyWith(devOverrideStatus: status, clearDevOverride: status == null);
    if (status == DeviceStatus.filling) {
      await startFlow();
    } else if (status == DeviceStatus.noContainer || status == DeviceStatus.full) {
      await stopFlow();
    } else {
      unawaited(_pollOnce());
    }
  }

  Future<void> _performAction(Future<void> Function() action) async {
    state = state.copyWith(executingAction: true, clearError: true);
    try {
      await action();
      await _pollOnce();
    } catch (error) {
      state = state.copyWith(errorMessage: 'Action failed: $error');
    } finally {
      state = state.copyWith(executingAction: false);
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
