import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/frosted_card.dart';
import '../../core/widgets/section_header.dart';
import '../../state/flowit_controller.dart';
import '../dashboard/widgets/mini_line_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flowitControllerProvider);
    final history = state.history;

    final totalLiters = history.fold<double>(0, (acc, entry) => acc + entry.volumeLiters);
    final avgSession = history.isEmpty ? 0 : totalLiters / history.length;
    final fills = history.length;
    final savedWater = totalLiters * 0.1;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          FrostedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Usage Stats'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _StatChip(label: 'Total Water Saved', value: '${savedWater.toStringAsFixed(2)} L'),
                    _StatChip(label: 'Avg / Session', value: '${avgSession.toStringAsFixed(2)} L'),
                    _StatChip(label: 'Number of Fills', value: '$fills'),
                    _StatChip(label: 'Total Consumption', value: '${totalLiters.toStringAsFixed(2)} L'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FrostedCard(
            child: Column(
              children: [
                MiniLineChart(points: state.usagePoints, color: const Color(0xFF2A9D8F), title: 'Daily Water Consumption', height: 150),
                const SizedBox(height: 12),
                MiniLineChart(points: state.flowPoints, color: const Color(0xFF00A8E8), title: 'Flow Rate History', height: 150),
                const SizedBox(height: 12),
                MiniLineChart(
                  points: state.temperaturePoints,
                  color: const Color(0xFFE76F51),
                  title: 'Temperature Trend',
                  height: 150,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FrostedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Session Logs'),
                const SizedBox(height: 10),
                if (history.isEmpty)
                  const Text('No sessions recorded yet.')
                else
                  ...history.reversed.take(10).map(
                    (entry) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(entry.aligned ? Icons.task_alt : Icons.warning_amber, color: entry.aligned ? const Color(0xFF2A9D8F) : const Color(0xFFE76F51)),
                      title: Text('${entry.volumeLiters.toStringAsFixed(2)} L  •  ${entry.avgFlowRate.toStringAsFixed(2)} L/min'),
                      subtitle: Text('${DateFormat('dd MMM, HH:mm').format(entry.startedAt)} - ${DateFormat('HH:mm').format(entry.endedAt)}'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.72),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
