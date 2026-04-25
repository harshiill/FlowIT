import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_constants.dart';

class HeatmapGrid extends StatelessWidget {
  const HeatmapGrid({
    super.key,
    required this.grid,
    required this.cluster,
    required this.rimActive,
    required this.centroidRow,
    required this.centroidCol,
  });

  final List<double> grid;
  final List<bool> cluster;
  final List<bool> rimActive;
  final int centroidRow;
  final int centroidCol;

  @override
  Widget build(BuildContext context) {
    final clipped = grid.take(AppConstants.heatmapTotalCells).toList(growable: false);
    final minValue = clipped.isEmpty ? 0.0 : clipped.reduce((a, b) => a < b ? a : b);
    final maxValue = clipped.isEmpty ? 1.0 : clipped.reduce((a, b) => a > b ? a : b);

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
          final value = index < clipped.length ? clipped[index] : 0.0;
          final normalized = maxValue - minValue < 0.0001
              ? 0.0
              : (value - minValue) / (maxValue - minValue);

          final row = index ~/ AppConstants.heatmapGridSize;
          final col = index % AppConstants.heatmapGridSize;
          final isCentroid = row == centroidRow && col == centroidCol;
          final isCluster = index < cluster.length && cluster[index];
          final isRim = index < rimActive.length && rimActive[index];

          return _HeatmapCell(
            value: normalized,
            isCentroid: isCentroid,
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
    required this.value,
    required this.isCentroid,
    required this.isCluster,
    required this.isRim,
  });

  final double value;
  final bool isCentroid;
  final bool isCluster;
  final bool isRim;

  @override
  State<_HeatmapCell> createState() => _HeatmapCellState();
}

class _HeatmapCellState extends State<_HeatmapCell> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: AppConstants.durationVerySlow * 2,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isCentroid) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_HeatmapCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCentroid && !oldWidget.isCentroid) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isCentroid && oldWidget.isCentroid) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getHeatmapColor(double normalizedValue) {
    // Gradient from error (cold/low) to primary blue (hot/high)
    return Color.lerp(
      AppTheme.error,
      AppTheme.primaryBlue,
      normalizedValue,
    )!;
  }

  Color _getBorderColor() {
    if (widget.isCentroid) return AppTheme.backgroundWhite;
    if (widget.isCluster) return AppTheme.success;
    if (widget.isRim) return AppTheme.warning;
    return Colors.transparent;
  }

  double _getBorderWidth() {
    if (widget.isCentroid) return 2.5;
    if (widget.isCluster || widget.isRim) return 1.8;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final cellColor = _getHeatmapColor(widget.value);
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
          boxShadow: _isHovered || widget.isCentroid
              ? [
                  BoxShadow(
                    color: cellColor.withOpacity(0.5),
                    blurRadius: _isHovered ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: widget.isCentroid
            ? ScaleTransition(
                scale: _pulseAnimation,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(AppConstants.space4),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.my_location_rounded,
                      size: 10,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              )
            : _isHovered
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundWhite.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(AppConstants.radiusXs),
                      ),
                      child: Text(
                        widget.value.toStringAsFixed(2),
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
