class SessionEntry {
  const SessionEntry({
    required this.startedAt,
    required this.endedAt,
    required this.volumeLiters,
    required this.avgFlowRate,
    required this.avgTemperature,
    required this.aligned,
  });

  final DateTime startedAt;
  final DateTime endedAt;
  final double volumeLiters;
  final double avgFlowRate;
  final double avgTemperature;
  final bool aligned;

  Duration get duration => endedAt.difference(startedAt);

  Map<String, dynamic> toJson() {
    return {
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
      'volumeLiters': volumeLiters,
      'avgFlowRate': avgFlowRate,
      'avgTemperature': avgTemperature,
      'aligned': aligned,
    };
  }

  factory SessionEntry.fromJson(Map<String, dynamic> json) {
    return SessionEntry(
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      volumeLiters: (json['volumeLiters'] as num?)?.toDouble() ?? 0,
      avgFlowRate: (json['avgFlowRate'] as num?)?.toDouble() ?? 0,
      avgTemperature: (json['avgTemperature'] as num?)?.toDouble() ?? 0,
      aligned: (json['aligned'] as bool?) ?? false,
    );
  }
}

class MetricPoint {
  const MetricPoint(this.time, this.value);

  final DateTime time;
  final double value;
}
