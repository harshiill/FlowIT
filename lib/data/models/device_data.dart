import 'package:flutter/material.dart';

enum DeviceStatus {
  noContainer,
  filling,
  full,
  alignBucket,
  handDetected,
  manualMode,
  unknown,
}

extension DeviceStatusX on DeviceStatus {
  String get label {
    switch (this) {
      case DeviceStatus.noContainer:
        return 'NO CONTAINER';
      case DeviceStatus.filling:
        return 'FILLING';
      case DeviceStatus.full:
        return 'FULL';
      case DeviceStatus.alignBucket:
        return 'ALIGN BUCKET';
      case DeviceStatus.handDetected:
        return 'HAND DETECTED';
      case DeviceStatus.manualMode:
        return 'MANUAL MODE';
      case DeviceStatus.unknown:
        return 'UNKNOWN';
    }
  }

  Color get color {
    switch (this) {
      case DeviceStatus.noContainer:
        return const Color(0xFFE76F51);
      case DeviceStatus.filling:
        return const Color(0xFF2A9D8F);
      case DeviceStatus.full:
        return const Color(0xFF006D77);
      case DeviceStatus.alignBucket:
        return const Color(0xFFF4A261);
      case DeviceStatus.handDetected:
        return const Color(0xFF8E9AAF);
      case DeviceStatus.manualMode:
        return const Color(0xFF264653);
      case DeviceStatus.unknown:
        return const Color(0xFF9AA0A6);
    }
  }
}

class DeviceData {
  const DeviceData({
    required this.grid,
    required this.cluster,
    required this.rimActive,
    required this.centroidRow,
    required this.centroidCol,
    required this.centerLocal,
    required this.flowRate,
    required this.volume,
    required this.temperature,
    required this.status,
    required this.isManual,
    required this.tapOn,
    required this.totalConsumed,
    required this.updatedAt,
  });

  final List<double> grid;
  final List<bool> cluster;
  final List<bool> rimActive;
  final int centroidRow;
  final int centroidCol;
  final bool centerLocal;
  final double flowRate;
  final double volume;
  final double temperature;
  final DeviceStatus status;
  final bool isManual;
  final bool tapOn;
  final double totalConsumed;
  final DateTime updatedAt;

  DeviceData copyWith({
    List<double>? grid,
    List<bool>? cluster,
    List<bool>? rimActive,
    int? centroidRow,
    int? centroidCol,
    bool? centerLocal,
    double? flowRate,
    double? volume,
    double? temperature,
    DeviceStatus? status,
    bool? isManual,
    bool? tapOn,
    double? totalConsumed,
    DateTime? updatedAt,
  }) {
    return DeviceData(
      grid: grid ?? this.grid,
      cluster: cluster ?? this.cluster,
      rimActive: rimActive ?? this.rimActive,
      centroidRow: centroidRow ?? this.centroidRow,
      centroidCol: centroidCol ?? this.centroidCol,
      centerLocal: centerLocal ?? this.centerLocal,
      flowRate: flowRate ?? this.flowRate,
      volume: volume ?? this.volume,
      temperature: temperature ?? this.temperature,
      status: status ?? this.status,
      isManual: isManual ?? this.isManual,
      tapOn: tapOn ?? this.tapOn,
      totalConsumed: totalConsumed ?? this.totalConsumed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get aligned => centerLocal;

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    List<T> parseFixedList<T>(dynamic source, T Function(dynamic) parser) {
      if (source is! List) return List<T>.filled(64, parser(0));
      final parsed = source.map(parser).toList(growable: false);
      if (parsed.length >= 64) {
        return parsed.take(64).toList(growable: false);
      }
      return [...parsed, ...List<T>.filled(64 - parsed.length, parser(0))];
    }

    DeviceStatus parseStatus(String raw) {
      final normalized = raw.trim().toUpperCase().replaceAll(' ', '_');
      switch (normalized) {
        case 'NO_CONTAINER':
          return DeviceStatus.noContainer;
        case 'FILLING':
          return DeviceStatus.filling;
        case 'FULL':
          return DeviceStatus.full;
        case 'ALIGN_BUCKET':
          return DeviceStatus.alignBucket;
        case 'HAND_DETECTED':
          return DeviceStatus.handDetected;
        case 'MANUAL_MODE':
          return DeviceStatus.manualMode;
        default:
          return DeviceStatus.unknown;
      }
    }

    return DeviceData(
      grid: parseFixedList<double>(json['grid'], (value) => (value as num?)?.toDouble() ?? 0),
      cluster: parseFixedList<bool>(json['cluster'], (value) => value == 1 || value == true),
      rimActive: parseFixedList<bool>(json['rimActive'], (value) => value == 1 || value == true),
      centroidRow: (json['centroidRow'] as num?)?.toInt() ?? 0,
      centroidCol: (json['centroidCol'] as num?)?.toInt() ?? 0,
      centerLocal: (json['centerLocal'] as bool?) ?? false,
      flowRate: (json['flowRate'] as num?)?.toDouble() ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0,
      status: parseStatus((json['status'] as String?) ?? 'UNKNOWN'),
      isManual: (json['isManual'] as bool?) ?? false,
      tapOn: (json['tapOn'] as bool?) ?? ((json['flowRate'] as num?)?.toDouble() ?? 0) > 0,
      totalConsumed: (json['totalConsumed'] as num?)?.toDouble() ?? 0,
      updatedAt: DateTime.now(),
    );
  }
}
