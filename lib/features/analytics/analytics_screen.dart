import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_constants.dart';
import '../../core/theme/app_theme.dart';
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

    final totalLiters = history.fold<double>(
      0,
      (acc, entry) => acc + entry.volumeLiters,
    );
    final avgSession = history.isEmpty ? 0 : totalLiters / history.length;
    final fills = history.length;
    final savedWater = totalLiters * 0.1;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.space16,
        AppConstants.space16,
        AppConstants.space16,
        AppConstants.space24,
      ),
      child: Column(
        children: [
          // Usage Stats Section
          FrostedCard(
            elevation: CardElevation.medium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Usage Statistics',
                  size: SectionHeaderSize.medium,
                ),
                const SizedBox(height: AppConstants.space16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive stat chips layout
                    return Wrap(
                      spacing: AppConstants.space12,
                      runSpacing: AppConstants.space12,
                      children: [
                        _StatCard(
                          label: 'Water Saved',
                          value: savedWater.toStringAsFixed(2),
                          unit: 'L',
                          icon: Icons.water_drop,
                          iconColor: AppTheme.success,
                          iconBackgroundColor: AppTheme.successLight,
                          width: constraints.maxWidth > 600
                              ? (constraints.maxWidth - AppConstants.space36) /
                                    4
                              : (constraints.maxWidth - AppConstants.space12) /
                                    2,
                        ),
                        _StatCard(
                          label: 'Avg Session',
                          value: avgSession.toStringAsFixed(2),
                          unit: 'L',
                          icon: Icons.analytics_outlined,
                          iconColor: AppTheme.info,
                          iconBackgroundColor: AppTheme.infoLight,
                          width: constraints.maxWidth > 600
                              ? (constraints.maxWidth - AppConstants.space36) /
                                    4
                              : (constraints.maxWidth - AppConstants.space12) /
                                    2,
                        ),
                        _StatCard(
                          label: 'Total Fills',
                          value: fills.toString(),
                          unit: '',
                          icon: Icons.format_list_numbered_rounded,
                          iconColor: AppTheme.primaryBlue,
                          iconBackgroundColor: AppTheme.accentBluePale,
                          width: constraints.maxWidth > 600
                              ? (constraints.maxWidth - AppConstants.space36) /
                                    4
                              : (constraints.maxWidth - AppConstants.space12) /
                                    2,
                        ),
                        _StatCard(
                          label: 'Total Usage',
                          value: totalLiters.toStringAsFixed(2),
                          unit: 'L',
                          icon: Icons.opacity,
                          iconColor: AppTheme.accentBlue,
                          iconBackgroundColor: AppTheme.accentBluePale,
                          width: constraints.maxWidth > 600
                              ? (constraints.maxWidth - AppConstants.space36) /
                                    4
                              : (constraints.maxWidth - AppConstants.space12) /
                                    2,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.space16),

          // Charts Section
          FrostedCard(
            elevation: CardElevation.medium,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive chart height
                final chartHeight = constraints.maxWidth > 600
                    ? AppConstants.chartHeightLg
                    : AppConstants.chartHeightMd;

                return Column(
                  children: [
                    MiniLineChart(
                      points: state.usagePoints,
                      color: AppTheme.success,
                      title: 'Daily Water Consumption',
                      height: chartHeight,
                    ),
                    const SizedBox(height: AppConstants.space20),
                    Divider(height: 1, color: AppTheme.borderLight),
                    const SizedBox(height: AppConstants.space20),
                    MiniLineChart(
                      points: state.flowPoints,
                      color: AppTheme.accentBlue,
                      title: 'Flow Rate History',
                      height: chartHeight,
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: AppConstants.space16),

          // Session Logs Section
          FrostedCard(
            elevation: CardElevation.medium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeaderWithBadge(
                  title: 'Recent Sessions',
                  count: history.length,
                  size: SectionHeaderSize.medium,
                ),
                const SizedBox(height: AppConstants.space12),
                if (history.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.space24,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: AppConstants.icon2xl,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(height: AppConstants.space12),
                          Text(
                            'No sessions recorded yet',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        history.length > AppConstants.maxSessionLogsDisplay
                        ? AppConstants.maxSessionLogsDisplay
                        : history.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: AppTheme.borderLight),
                    itemBuilder: (context, index) {
                      final entry = history.reversed.toList()[index];
                      return _SessionLogTile(entry: entry);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern stat card with icon, label, and value
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.width,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        color: AppTheme.surfaceGrey,
        border: Border.all(color: AppTheme.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: AppConstants.iconLg,
            height: AppConstants.iconLg,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Icon(icon, size: AppConstants.iconSm, color: iconColor),
          ),
          const SizedBox(height: AppConstants.space12),

          // Label
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.space4),

          // Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: AppConstants.space4),
                Text(
                  unit,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Session log list tile with enhanced styling
class _SessionLogTile extends StatelessWidget {
  const _SessionLogTile({required this.entry});

  final dynamic entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: AppConstants.space8,
      ),
      leading: Container(
        width: AppConstants.iconLg,
        height: AppConstants.iconLg,
        decoration: BoxDecoration(
          color: AppTheme.successLight,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        child: Icon(
          Icons.task_alt,
          color: AppTheme.success,
          size: AppConstants.iconSm,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              '${entry.volumeLiters.toStringAsFixed(2)} L',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space8,
              vertical: AppConstants.space4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.accentBluePale,
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: Text(
              '${entry.avgFlowRate.toStringAsFixed(2)} L/min',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.accentBlue,
              ),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppConstants.space4),
        child: Text(
          '${DateFormat('dd MMM, HH:mm').format(entry.startedAt)} - ${DateFormat('HH:mm').format(entry.endedAt)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }
}
