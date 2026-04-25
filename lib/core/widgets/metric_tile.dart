import 'package:flutter/material.dart';

import '../theme/app_constants.dart';
import '../theme/app_theme.dart';

/// Modern metric display tile for dashboard KPIs
///
/// Displays a metric with icon, label, value, and unit in a clean, card-based layout.
/// Supports different sizes, trend indicators, and custom styling.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.size = MetricTileSize.medium,
    this.iconColor,
    this.iconBackgroundColor,
    this.trend,
    this.trendValue,
    this.onTap,
    this.backgroundColor,
  });

  /// Metric label (e.g., "Flow Rate")
  final String label;

  /// Metric value (e.g., "2.5")
  final String value;

  /// Unit of measurement (e.g., "L/min")
  final String unit;

  /// Icon representing the metric
  final IconData icon;

  /// Size variant of the tile
  final MetricTileSize size;

  /// Custom icon color (defaults to primary blue)
  final Color? iconColor;

  /// Custom icon background color
  final Color? iconBackgroundColor;

  /// Trend direction (up, down, neutral)
  final MetricTrend? trend;

  /// Trend percentage value (e.g., "+12%")
  final String? trendValue;

  /// Callback when tile is tapped
  final VoidCallback? onTap;

  /// Custom background color
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppTheme.primaryBlue;
    final effectiveIconBgColor =
        iconBackgroundColor ?? AppTheme.primaryBlue.withOpacity(0.12);
    final effectiveBgColor = backgroundColor ?? AppTheme.surfaceWhite;

    final dimensions = _getDimensions(size);
    final textStyles = _getTextStyles(context, size);

    return AnimatedContainer(
      duration: AppConstants.durationNormal,
      curve: AppConstants.animationCurve,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: Padding(
            padding: EdgeInsets.all(dimensions.padding),
            child: _buildContent(
              context,
              effectiveIconColor,
              effectiveIconBgColor,
              dimensions,
              textStyles,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Color iconColor,
    Color iconBgColor,
    _MetricDimensions dimensions,
    _MetricTextStyles textStyles,
  ) {
    return Row(
      children: [
        // Icon container
        _IconContainer(
          icon: icon,
          size: dimensions.iconContainerSize,
          iconSize: dimensions.iconSize,
          color: iconColor,
          backgroundColor: iconBgColor,
        ),
        SizedBox(width: dimensions.spacing),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Label with optional trend
              Row(
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: textStyles.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trend != null && trendValue != null) ...[
                    const SizedBox(width: AppConstants.space4),
                    _TrendIndicator(
                      trend: trend!,
                      value: trendValue!,
                      size: size,
                    ),
                  ],
                ],
              ),
              SizedBox(height: dimensions.valueSpacing),

              // Value and unit
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: textStyles.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppConstants.space4),
                  Text(unit, style: textStyles.unit),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _MetricDimensions _getDimensions(MetricTileSize size) {
    switch (size) {
      case MetricTileSize.small:
        return const _MetricDimensions(
          padding: AppConstants.space8,
          iconContainerSize: 32,
          iconSize: 16,
          spacing: AppConstants.space8,
          valueSpacing: AppConstants.space4,
        );
      case MetricTileSize.medium:
        return const _MetricDimensions(
          padding: AppConstants.space12,
          iconContainerSize: 40,
          iconSize: 20,
          spacing: AppConstants.space12,
          valueSpacing: AppConstants.space4,
        );
      case MetricTileSize.large:
        return const _MetricDimensions(
          padding: AppConstants.space16,
          iconContainerSize: 48,
          iconSize: 24,
          spacing: AppConstants.space16,
          valueSpacing: AppConstants.space8,
        );
    }
  }

  _MetricTextStyles _getTextStyles(BuildContext context, MetricTileSize size) {
    final theme = Theme.of(context);

    switch (size) {
      case MetricTileSize.small:
        return _MetricTextStyles(
          label: theme.textTheme.labelSmall!.copyWith(
            color: AppTheme.textTertiary,
            fontWeight: FontWeight.w500,
          ),
          value: theme.textTheme.titleMedium!.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          unit: theme.textTheme.labelSmall!.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        );
      case MetricTileSize.medium:
        return _MetricTextStyles(
          label: theme.textTheme.bodySmall!.copyWith(
            color: AppTheme.textTertiary,
            fontWeight: FontWeight.w500,
          ),
          value: theme.textTheme.titleLarge!.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          unit: theme.textTheme.bodySmall!.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        );
      case MetricTileSize.large:
        return _MetricTextStyles(
          label: theme.textTheme.bodyMedium!.copyWith(
            color: AppTheme.textTertiary,
            fontWeight: FontWeight.w500,
          ),
          value: theme.textTheme.headlineSmall!.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          unit: theme.textTheme.bodyMedium!.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }
}

/// Icon container for metric tiles
class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.durationNormal,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}

/// Trend indicator showing metric changes
class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({
    required this.trend,
    required this.value,
    required this.size,
  });

  final MetricTrend trend;
  final String value;
  final MetricTileSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getTrendColor();
    final icon = _getTrendIcon();
    final fontSize = size == MetricTileSize.small ? 9.0 : 10.0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusXs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 2, color: color),
          const SizedBox(width: 2),
          Text(
            value,
            style: theme.textTheme.labelSmall!.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrendColor() {
    switch (trend) {
      case MetricTrend.up:
        return AppTheme.success;
      case MetricTrend.down:
        return AppTheme.error;
      case MetricTrend.neutral:
        return AppTheme.textTertiary;
    }
  }

  IconData _getTrendIcon() {
    switch (trend) {
      case MetricTrend.up:
        return Icons.trending_up_rounded;
      case MetricTrend.down:
        return Icons.trending_down_rounded;
      case MetricTrend.neutral:
        return Icons.trending_flat_rounded;
    }
  }
}

/// Compact metric tile variant (vertical layout)
class CompactMetricTile extends StatelessWidget {
  const CompactMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? AppTheme.primaryBlue;
    final effectiveBgColor = backgroundColor ?? AppTheme.surfaceWhite;

    return AnimatedContainer(
      duration: AppConstants.durationNormal,
      padding: const EdgeInsets.all(AppConstants.space12),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppConstants.iconMd, color: effectiveIconColor),
          const SizedBox(height: AppConstants.space8),
          Text(
            label,
            style: theme.textTheme.bodySmall!.copyWith(
              color: AppTheme.textTertiary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.space4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppConstants.space4),
              Text(
                unit,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== ENUMS & DATA CLASSES ====================

/// Size variants for metric tiles
enum MetricTileSize { small, medium, large }

/// Trend direction for metric changes
enum MetricTrend { up, down, neutral }

/// Internal class for metric dimensions
class _MetricDimensions {
  const _MetricDimensions({
    required this.padding,
    required this.iconContainerSize,
    required this.iconSize,
    required this.spacing,
    required this.valueSpacing,
  });

  final double padding;
  final double iconContainerSize;
  final double iconSize;
  final double spacing;
  final double valueSpacing;
}

/// Internal class for metric text styles
class _MetricTextStyles {
  const _MetricTextStyles({
    required this.label,
    required this.value,
    required this.unit,
  });

  final TextStyle label;
  final TextStyle value;
  final TextStyle unit;
}
