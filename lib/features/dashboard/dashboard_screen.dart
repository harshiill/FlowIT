import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_constants.dart';
import '../../core/widgets/connection_prompt.dart';
import '../../core/widgets/flowit_logo.dart';
import '../../core/widgets/frosted_card.dart';
import '../../core/widgets/metric_tile.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/device_data.dart';
import '../connection/connection_screen.dart';
import '../../state/flowit_controller.dart';
import '../../state/flowit_state.dart';
import 'widgets/alerts_list.dart';
import 'widgets/heatmap_grid.dart';
import 'widgets/mini_line_chart.dart';
import 'widgets/status_strip.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flowitControllerProvider);
    final data = state.latestData;

    // Show connection prompt if baseUrl not configured yet
    if (state.baseUrl.isEmpty) {
      return _buildConnectionPrompt(context, state);
    }

    // Show loading or error states
    if (data == null) {
      if (state.connectionState == ConnectionStateX.connected &&
          state.errorMessage == null) {
        return _buildLoadingState();
      }

      return _buildConnectionPrompt(context, state);
    }

    final lifetime =
        state.history.fold<double>(0, (acc, item) => acc + item.volumeLiters) +
        data.totalConsumed;

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.read(flowitControllerProvider.notifier).startPolling(),
        color: AppTheme.primaryBlue,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(context, state),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.space16,
                AppConstants.space8,
                AppConstants.space16,
                AppConstants.space24,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  _buildSystemStatusCard(data, state),
                  const SizedBox(height: AppConstants.space16),
                  _buildLiveMetricsCard(data, lifetime),
                  const SizedBox(height: AppConstants.space16),
                  _buildSmartSensorCard(context, data),
                  const SizedBox(height: AppConstants.space16),
                  _buildTrendsCard(state),
                  const SizedBox(height: AppConstants.space16),
                  _buildSmartAlertsCard(state),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build modern app bar with logo and connection status
  Widget _buildAppBar(BuildContext context, FlowItState state) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.backgroundWhite,
      surfaceTintColor: AppTheme.backgroundWhite,
      title: const _SecretDevLogo(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppConstants.space16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space12,
              vertical: AppConstants.space8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surfaceBlue,
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              border: Border.all(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.router_rounded,
                  size: AppConstants.iconSm,
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(width: AppConstants.space8),
                Text(
                  state.baseUrl.replaceFirst('http://', ''),
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build system status card
  Widget _buildSystemStatusCard(DeviceData data, FlowItState state) {
    return FrostedCard(
      elevation: CardElevation.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'System Status',
            size: SectionHeaderSize.medium,
          ),
          const SizedBox(height: AppConstants.space12),
          StatusStrip(
            status: data.status,
            tapOn: data.tapOn,
            connectionState: state.connectionState,
            aligned: data.aligned,
          ),
        ],
      ),
    );
  }

  /// Build live metrics card with grid of metric tiles
  Widget _buildLiveMetricsCard(DeviceData data, double lifetime) {
    return FrostedCard(
      elevation: CardElevation.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Live Metrics',
            size: SectionHeaderSize.medium,
          ),
          const SizedBox(height: AppConstants.space16),
          GridView.count(
            crossAxisCount: AppConstants.gridColumns2,
            childAspectRatio: AppConstants.metricTileAspectRatio,
            mainAxisSpacing: AppConstants.space12,
            crossAxisSpacing: AppConstants.space12,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              MetricTile(
                label: 'Flow Rate',
                value: data.flowRate.toStringAsFixed(2),
                unit: 'L/min',
                icon: Icons.water_drop_outlined,
                size: MetricTileSize.medium,
              ),
              MetricTile(
                label: 'Session Usage',
                value: data.volume.toStringAsFixed(0),
                unit: 'mL',
                icon: Icons.local_drink_outlined,
                size: MetricTileSize.medium,
              ),
              MetricTile(
                label: 'Total Consumed',
                value: lifetime.toStringAsFixed(2),
                unit: 'L',
                icon: Icons.monitor_heart_outlined,
                size: MetricTileSize.medium,
              ),
              MetricTile(
                label: 'Temperature',
                value: data.temperature.toStringAsFixed(1),
                unit: '°C',
                icon: Icons.thermostat_outlined,
                size: MetricTileSize.medium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build smart sensor heatmap card
  Widget _buildSmartSensorCard(BuildContext context, DeviceData data) {
    return FrostedCard(
      elevation: CardElevation.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Smart Sensor 8×8',
            size: SectionHeaderSize.medium,
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.space12,
                vertical: AppConstants.space8,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surfaceBlue,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                border: Border.all(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.my_location_rounded,
                    size: AppConstants.iconXs,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: AppConstants.space4),
                  Text(
                    'Centroid (${data.centroidRow}, ${data.centroidCol})',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.space16),
          HeatmapGrid(
            grid: data.grid,
            cluster: data.cluster,
            rimActive: data.rimActive,
            centroidRow: data.centroidRow,
            centroidCol: data.centroidCol,
          ),
        ],
      ),
    );
  }

  /// Build trends card with line charts
  Widget _buildTrendsCard(FlowItState state) {
    return FrostedCard(
      elevation: CardElevation.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Trends', size: SectionHeaderSize.medium),
          const SizedBox(height: AppConstants.space16),
          MiniLineChart(
            points: state.flowPoints,
            color: AppTheme.primaryBlue,
            title: 'Flow Rate Trend',
          ),
          const SizedBox(height: AppConstants.space16),
          MiniLineChart(
            points: state.usagePoints,
            color: AppTheme.success,
            title: 'Water Usage Trend',
          ),
        ],
      ),
    );
  }

  /// Build smart alerts card
  Widget _buildSmartAlertsCard(FlowItState state) {
    return FrostedCard(
      elevation: CardElevation.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderWithBadge(
            title: 'Smart Alerts',
            count: state.alerts.length,
            size: SectionHeaderSize.medium,
            badgeColor: state.alerts.isEmpty
                ? AppTheme.textTertiary
                : AppTheme.warning,
          ),
          const SizedBox(height: AppConstants.space12),
          AlertsList(alerts: state.alerts),
        ],
      ),
    );
  }

  /// Build modern loading state
  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.space24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceBlue,
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                boxShadow: AppTheme.shadowMd,
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: AppConstants.space24),
            Text(
              'Loading dashboard data...',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.space8),
            Text(
              'Please wait while we fetch the latest metrics',
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build connection prompt with modern design
  Widget _buildConnectionPrompt(BuildContext context, FlowItState state) {
    return ConnectionPrompt(
      connectionState: state.connectionState,
      errorMessage: state.errorMessage,
      onGoToConnection: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ConnectionScreen()),
        );
      },
    );
  }
}

/// Secret Developer Logo with tap counter
class _SecretDevLogo extends ConsumerStatefulWidget {
  const _SecretDevLogo();

  @override
  ConsumerState<_SecretDevLogo> createState() => _SecretDevLogoState();
}

class _SecretDevLogoState extends ConsumerState<_SecretDevLogo> {
  int _taps = 0;
  DateTime? _lastTap;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTap == null || now.difference(_lastTap!) > const Duration(milliseconds: 500)) {
      _taps = 1;
    } else {
      _taps++;
    }
    _lastTap = now;

    if (_taps >= 5) {
      _taps = 0;
      _showDevMenu();
    }
  }

  void _showDevMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusXl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.space24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.developer_mode, color: AppTheme.primaryBlue),
                    const SizedBox(width: AppConstants.space12),
                    Text(
                      'Developer Options',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.space24),
                _buildDevButton(
                  'Force NO CONTAINER',
                  DeviceStatus.noContainer.color,
                  () => _setOverride(DeviceStatus.noContainer),
                ),
                const SizedBox(height: AppConstants.space12),
                _buildDevButton(
                  'Force FILLING',
                  DeviceStatus.filling.color,
                  () => _setOverride(DeviceStatus.filling),
                ),
                const SizedBox(height: AppConstants.space12),
                _buildDevButton(
                  'Force FULL',
                  DeviceStatus.full.color,
                  () => _setOverride(DeviceStatus.full),
                ),
                const SizedBox(height: AppConstants.space24),
                OutlinedButton(
                  onPressed: () => _setOverride(null),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.space16),
                    side: const BorderSide(color: AppTheme.borderMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                  child: const Text('Clear Override', style: TextStyle(color: AppTheme.textSecondary)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _setOverride(DeviceStatus? status) {
    ref.read(flowitControllerProvider.notifier).setDevOverride(status);
    Navigator.of(context).pop();
  }

  Widget _buildDevButton(String label, Color color, VoidCallback onTap) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: AppConstants.space16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flowitControllerProvider);
    final isOverridden = state.devOverrideStatus != null;
    
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FlowItLogo(size: 18, style: FlowItLogoStyle.text),
          if (isOverridden) ...[
            const SizedBox(width: AppConstants.space8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'DEV',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.warning,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
