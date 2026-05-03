import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_constants.dart';

class HeatmapGrid extends StatelessWidget {
  const HeatmapGrid({
    super.key,
    required this.grid,
    required this.cluster,
    required this.rimActive,
  });

  final List<int> grid;
  final List<int> cluster;
  final List<int> rimActive;

  @override
  Widget build(BuildContext context) {
    final clipped = grid.take(AppConstants.heatmapTotalCells).toList(growable: false);
    final minValue = clipped.isEmpty ? 0 : clipped.reduce((a, b) => a < b ? a : b);
    final maxValue = clipped.isEmpty ? 1 : clipped.reduce((a, b) => a > b ? a : b);

    return RepaintBoundary(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: AppConstants.heatmapTotalCells,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppConstants.heatmapGridSize,
          mainAxisSpacing: AppConstants.space4,
          crossAxisSpacing: AppConstants.space4,
        ),
        itemBuilder: (context, index) {
          final value = index < clipped.length ? clipped[index] : 0;
          final normalized = maxValue - minValue == 0
              ? 0.0
              : (value - minValue) / (maxValue - minValue);

          final isCluster = index < cluster.length && cluster[index] == 1;
          final isRim = index < rimActive.length && rimActive[index] == 1;

          return _HeatmapCell(
            normalizedValue: normalized,
            rawValue: value,
            isCluster: isCluster,
            isRim: isRim,
          );
        },
      ),
    );
  }
}

class _HeatmapCell extends StatefulWidget {
  const _HeatmapCell({
    required this.normalizedValue,
    required this.rawValue,
    required this.isCluster,
    required this.isRim,
  });

  final double normalizedValue;
  final int rawValue;
  final bool isCluster;
  final bool isRim;

  @override
  State<_HeatmapCell> createState() => _HeatmapCellState();
}

class _HeatmapCellState extends State<_HeatmapCell> {
  bool _isHovered = false;

  Color _getHeatmapColor(double normalizedValue) {
    // Gradient from error (cold/low) to primary blue (hot/high)
    return Color.lerp(
      AppTheme.error,
      AppTheme.primaryBlue,
      normalizedValue,
    )!;
  }

  Color _getBorderColor() {
    if (widget.isCluster) return AppTheme.success;
    if (widget.isRim) return AppTheme.warning;
    return Colors.transparent;
  }

  double _getBorderWidth() {
    if (widget.isCluster || widget.isRim) return 1.8;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final cellColor = _getHeatmapColor(widget.normalizedValue);
    final borderColor = _getBorderColor();
    final borderWidth = _getBorderWidth();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.durationNormal,
        curve: AppConstants.animationCurve,
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: cellColor.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: _isHovered
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXs),
                  ),
                  child: Text(
                    widget.rawValue.toString(),
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
