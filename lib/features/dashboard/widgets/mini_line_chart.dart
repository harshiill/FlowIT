import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_constants.dart';
import '../../../data/models/history_entry.dart';

class MiniLineChart extends StatefulWidget {
  const MiniLineChart({
    super.key,
    required this.points,
    required this.color,
    required this.title,
    this.height = 120,
  });

  final List<MetricPoint> points;
  final Color color;
  final String title;
  final double height;

  @override
  State<MiniLineChart> createState() => _MiniLineChartState();
}

class _MiniLineChartState extends State<MiniLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.durationSlow,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: AppConstants.animationCurveEaseOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) {
      return _buildEmptyState(context);
    }

    final spots = widget.points
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList(growable: false);

    final minY = widget.points.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final maxY = widget.points.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    final yRange = maxY - minY;
    final baseline = yRange.abs() < 0.0001 ? maxY + 1 : maxY;
    final floor = yRange.abs() < 0.0001 ? minY - 1 : minY;

    return SizedBox(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: AppConstants.space12),
          Expanded(
            child: FadeTransition(
              opacity: _animation,
              child: _buildChart(context, spots, floor, baseline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final currentValue = widget.points.isNotEmpty
        ? widget.points.last.value
        : 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.3,
                ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.space8,
            vertical: AppConstants.space4,
          ),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            border: Border.all(
              color: widget.color.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppConstants.space4),
              Text(
                currentValue.toStringAsFixed(1),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: widget.color,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<FlSpot> spots, double minY, double maxY) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: widget.points.isEmpty ? 1 : (widget.points.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.borderLight,
              strokeWidth: 1.0,
              dashArray: [4, 4],
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: AppTheme.borderMedium,
              width: 1.5,
            ),
            left: BorderSide(
              color: AppTheme.borderMedium,
              width: 1.5,
            ),
          ),
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppTheme.surfaceWhite,
            tooltipRoundedRadius: AppConstants.radiusSm,
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: AppConstants.space8,
              vertical: AppConstants.space4,
            ),
            tooltipBorder: BorderSide(
              color: widget.color.withOpacity(0.3),
              width: 1.5,
            ),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  spot.y.toStringAsFixed(2),
                  TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (response == null || response.lineBarSpots == null) {
              setState(() => _hoveredIndex = null);
              return;
            }
            setState(() {
              _hoveredIndex = response.lineBarSpots!.first.spotIndex;
            });
          },
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: widget.color.withOpacity(0.5),
                  strokeWidth: 2,
                  dashArray: [4, 4],
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: AppTheme.surfaceWhite,
                      strokeWidth: 2.5,
                      strokeColor: widget.color,
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: widget.color,
            isCurved: true,
            curveSmoothness: 0.4,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isHovered = index == _hoveredIndex;
                return FlDotCirclePainter(
                  radius: isHovered ? 4 : 2.5,
                  color: isHovered
                      ? AppTheme.surfaceWhite
                      : widget.color,
                  strokeWidth: isHovered ? 2 : 0,
                  strokeColor: isHovered ? widget.color : Colors.transparent,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.color.withOpacity(0.3),
                  widget.color.withOpacity(0.05),
                ],
              ),
            ),
            shadow: Shadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ),
        ],
      ),
      duration: AppConstants.durationNormal,
      curve: AppConstants.animationCurve,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
          ),
          SizedBox(height: AppConstants.space12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceGrey,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: AppTheme.borderLight,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart_rounded,
                      size: AppConstants.iconLg,
                      color: AppTheme.textTertiary,
                    ),
                    SizedBox(height: AppConstants.space8),
                    Text(
                      'No data available',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
