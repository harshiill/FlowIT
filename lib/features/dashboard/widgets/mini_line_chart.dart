import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/models/history_entry.dart';

class MiniLineChart extends StatelessWidget {
  const MiniLineChart({super.key, required this.points, required this.color, required this.title, this.height = 120});

  final List<MetricPoint> points;
  final Color color;
  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    final spots = points
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList(growable: false);

    final minY = points.isEmpty
      ? 0.0
      : points.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final maxY = points.isEmpty
      ? 1.0
      : points.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    final baseline = (maxY - minY).abs() < 0.0001 ? maxY + 1 : maxY;

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: points.isEmpty ? 1 : (points.length - 1).toDouble(),
                minY: minY,
                maxY: baseline,
                gridData: FlGridData(show: true, horizontalInterval: (baseline - minY) / 3),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    color: color,
                    isCurved: true,
                    barWidth: 2.2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.18)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
