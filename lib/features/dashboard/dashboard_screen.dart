import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/connection_prompt.dart';
import '../../core/widgets/flowit_logo.dart';
import '../../core/widgets/frosted_card.dart';
import '../../core/widgets/metric_tile.dart';
import '../../core/widgets/section_header.dart';
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
      return Center(
        child: ConnectionPrompt(
          connectionState: state.connectionState,
          errorMessage: state.errorMessage,
          onGoToConnection: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('👉 Tap the "Connection" tab at the bottom to configure your ESP32.')),
            );
          },
        ),
      );
    }
    if (data == null) {
      return const SizedBox.shrink();
    }


    final lifetime = state.history.fold<double>(0, (acc, item) => acc + item.volumeLiters) + data.totalConsumed;

    return RefreshIndicator(
      onRefresh: () async => ref.read(flowitControllerProvider.notifier).startPolling(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            title: const FlowItLogo(size: 18, style: FlowItLogoStyle.text),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Chip(
                  label: Text('${state.baseUrl.replaceFirst('http://', '')} '),
                  avatar: const Icon(Icons.router, size: 16),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                FrostedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'System Status'),
                      const SizedBox(height: 10),
                      StatusStrip(
                        status: data.status,
                        tapOn: data.tapOn,
                        connectionState: state.connectionState,
                        aligned: data.aligned,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FrostedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Live Metrics'),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.25,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          MetricTile(label: 'Flow Rate', value: data.flowRate.toStringAsFixed(2), unit: 'L/min', icon: Icons.water_drop_outlined),
                          MetricTile(label: 'Session Usage', value: data.volume.toStringAsFixed(0), unit: 'mL', icon: Icons.local_drink_outlined),
                          MetricTile(label: 'Total Consumed', value: lifetime.toStringAsFixed(2), unit: 'L', icon: Icons.monitor_heart_outlined),
                          MetricTile(label: 'Temperature', value: data.temperature.toStringAsFixed(1), unit: '°C', icon: Icons.thermostat_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FrostedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: 'Smart Sensor 8×8',
                        trailing: Text(
                          'Centroid (${data.centroidRow}, ${data.centroidCol})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 10),
                      HeatmapGrid(
                        grid: data.grid,
                        cluster: data.cluster,
                        rimActive: data.rimActive,
                        centroidRow: data.centroidRow,
                        centroidCol: data.centroidCol,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FrostedCard(
                  child: Column(
                    children: [
                      MiniLineChart(points: state.flowPoints, color: const Color(0xFF00A8E8), title: 'Flow Rate Trend'),
                      const SizedBox(height: 10),
                      MiniLineChart(points: state.usagePoints, color: const Color(0xFF2A9D8F), title: 'Water Usage Trend'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FrostedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Smart Alerts'),
                      const SizedBox(height: 10),
                      AlertsList(alerts: state.alerts),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
