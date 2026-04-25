import 'package:flutter/material.dart';

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
    final clipped = grid.take(64).toList(growable: false);
    final minValue = clipped.isEmpty ? 0.0 : clipped.reduce((a, b) => a < b ? a : b);
    final maxValue = clipped.isEmpty ? 1.0 : clipped.reduce((a, b) => a > b ? a : b);

    return RepaintBoundary(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 64,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          final value = index < clipped.length ? clipped[index] : 0.0;
          final normalized = maxValue - minValue < 0.0001 ? 0.0 : (value - minValue) / (maxValue - minValue);
          final row = index ~/ 8;
          final col = index % 8;
          final isCentroid = row == centroidRow && col == centroidCol;
          final isCluster = index < cluster.length && cluster[index];
          final isRim = index < rimActive.length && rimActive[index];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: Color.lerp(const Color(0xFFE63946), const Color(0xFF1D9BF0), normalized),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCentroid
                    ? Colors.white
                    : isCluster
                        ? const Color(0xFF06D6A0)
                        : isRim
                            ? const Color(0xFFFFC857)
                            : Colors.transparent,
                width: isCentroid ? 2.2 : 1.4,
              ),
            ),
            child: isCentroid
                ? const Center(
                    child: Icon(Icons.adjust, size: 12, color: Colors.white),
                  )
                : null,
          );
        },
      ),
    );
  }
}
