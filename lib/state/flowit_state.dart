import '../data/models/device_data.dart';
import '../data/models/history_entry.dart';

enum ConnectionStateX { disconnected, connecting, connected, reconnecting }

enum AlertType { warning, success, info }

class AlertEvent {
  const AlertEvent({required this.message, required this.type, required this.timestamp});

  final String message;
  final AlertType type;
  final DateTime timestamp;
}

class FlowItParams {
  const FlowItParams({
    this.alignmentThreshold = 0.4,
    this.rimThreshold = 0.5,
    this.fullThreshold = 0.85,
    this.clusterMinSize = 4,
  });

  final double alignmentThreshold;
  final double rimThreshold;
  final double fullThreshold;
  final int clusterMinSize;

  FlowItParams copyWith({
    double? alignmentThreshold,
    double? rimThreshold,
    double? fullThreshold,
    int? clusterMinSize,
  }) {
    return FlowItParams(
      alignmentThreshold: alignmentThreshold ?? this.alignmentThreshold,
      rimThreshold: rimThreshold ?? this.rimThreshold,
      fullThreshold: fullThreshold ?? this.fullThreshold,
      clusterMinSize: clusterMinSize ?? this.clusterMinSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alignmentThreshold': alignmentThreshold,
      'rimThreshold': rimThreshold,
      'fullThreshold': fullThreshold,
      'clusterMinSize': clusterMinSize,
    };
  }
}

class FlowItState {
  const FlowItState({
    this.loading = true,
    this.executingAction = false,
    this.latestData,
    this.history = const [],
    this.flowPoints = const [],
    this.usagePoints = const [],
    this.temperaturePoints = const [],
    this.connectionState = ConnectionStateX.disconnected,
    this.errorMessage,
    this.baseUrl = 'http://192.168.4.1',
    this.params = const FlowItParams(),
    this.alerts = const [],
  });

  final bool loading;
  final bool executingAction;
  final DeviceData? latestData;
  final List<SessionEntry> history;
  final List<MetricPoint> flowPoints;
  final List<MetricPoint> usagePoints;
  final List<MetricPoint> temperaturePoints;
  final ConnectionStateX connectionState;
  final String? errorMessage;
  final String baseUrl;
  final FlowItParams params;
  final List<AlertEvent> alerts;

  FlowItState copyWith({
    bool? loading,
    bool? executingAction,
    DeviceData? latestData,
    List<SessionEntry>? history,
    List<MetricPoint>? flowPoints,
    List<MetricPoint>? usagePoints,
    List<MetricPoint>? temperaturePoints,
    ConnectionStateX? connectionState,
    String? errorMessage,
    String? baseUrl,
    FlowItParams? params,
    List<AlertEvent>? alerts,
    bool clearError = false,
  }) {
    return FlowItState(
      loading: loading ?? this.loading,
      executingAction: executingAction ?? this.executingAction,
      latestData: latestData ?? this.latestData,
      history: history ?? this.history,
      flowPoints: flowPoints ?? this.flowPoints,
      usagePoints: usagePoints ?? this.usagePoints,
      temperaturePoints: temperaturePoints ?? this.temperaturePoints,
      connectionState: connectionState ?? this.connectionState,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      baseUrl: baseUrl ?? this.baseUrl,
      params: params ?? this.params,
      alerts: alerts ?? this.alerts,
    );
  }
}
