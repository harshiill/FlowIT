import 'package:flutter/material.dart';

enum DeviceStatus {
  booting,
  calibrating,
  errorBlocked,
  noContainer,
  filling,
  full,
  handDetected,
  manualOverride,
  unknown,
}

extension DeviceStatusX on DeviceStatus {
  String get label {
    switch (this) {
      case DeviceStatus.booting:
        return 'BOOTING...';
      case DeviceStatus.calibrating:
        return 'CALIBRATING...';
      case DeviceStatus.errorBlocked:
        return 'ERROR: SENSOR BLOCKED';
      case DeviceStatus.noContainer:
        return 'NO CONTAINER';
      case DeviceStatus.filling:
        return 'FILLING';
      case DeviceStatus.full:
        return 'FULL';
      case DeviceStatus.handDetected:
        return 'HAND DETECTED';
      case DeviceStatus.manualOverride:
        return 'MANUAL OVERRIDE';
      case DeviceStatus.unknown:
        return 'UNKNOWN';
    }
  }

  Color get color {
    switch (this) {
      case DeviceStatus.booting:
      case DeviceStatus.calibrating:
        return const Color(0xFFF4A261);
      case DeviceStatus.errorBlocked:
        return const Color(0xFFE63946);
      case DeviceStatus.noContainer:
        return const Color(0xFFE76F51);
      case DeviceStatus.filling:
        return const Color(0xFF2A9D8F);
      case DeviceStatus.full:
        return const Color(0xFF006D77);
      case DeviceStatus.handDetected:
        return const Color(0xFF8E9AAF);
      case DeviceStatus.manualOverride:
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
    required this.rim,
    required this.center,
    required this.conf,
    required this.flowRate,
    required this.volume,
    required this.status,
    required this.isManual,
    required this.tapOn,
    required this.totalConsumed,
    required this.updatedAt,
  });

  final List<int> grid;
  final List<int> cluster;
  final List<int> rimActive;
  final int rim;
  final int center;
  final List<double> conf;
  final double flowRate;
  final double volume;
  final DeviceStatus status;
  final bool isManual;
  final bool tapOn;
  final double totalConsumed;
  final DateTime updatedAt;

  DeviceData copyWith({
    List<int>? grid,
    List<int>? cluster,
    List<int>? rimActive,
    int? rim,
    int? center,
    List<double>? conf,
    double? flowRate,
    double? volume,
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
      rim: rim ?? this.rim,
      center: center ?? this.center,
      conf: conf ?? this.conf,
      flowRate: flowRate ?? this.flowRate,
      volume: volume ?? this.volume,
      status: status ?? this.status,
      isManual: isManual ?? this.isManual,
      tapOn: tapOn ?? this.tapOn,
      totalConsumed: totalConsumed ?? this.totalConsumed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


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
        case 'BOOTING...':
        case 'BOOTING':
          return DeviceStatus.booting;
        case 'CALIBRATING...':
        case 'CALIBRATING':
          return DeviceStatus.calibrating;
        case 'ERROR:_SENSOR_BLOCKED':
        case 'SENSOR_BLOCKED':
          return DeviceStatus.errorBlocked;
        case 'ERROR:_NO_CONTAINER':
        case 'NO_CONTAINER':
          return DeviceStatus.noContainer;
        case 'FILLING...':
        case 'FILLING':
          return DeviceStatus.filling;
        case 'CONTAINER_FULL':
        case 'FULL':
          return DeviceStatus.full;
        case 'HAND_DETECTED':
          return DeviceStatus.handDetected;
        case 'MANUAL_OVERRIDE':
          return DeviceStatus.manualOverride;
        default:
          return DeviceStatus.unknown;
      }
    }

    return DeviceData(
      grid: parseFixedList<int>(json['grid'], (value) => (value as num?)?.toInt() ?? 0),
      cluster: parseFixedList<int>(json['cluster'], (value) => (value as num?)?.toInt() ?? 0),
      rimActive: parseFixedList<int>(json['rimActive'], (value) => (value as num?)?.toInt() ?? 0),
      rim: (json['rim'] as num?)?.toInt() ?? 0,
      center: (json['center'] as num?)?.toInt() ?? 0,
      conf: (json['conf'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? List.filled(8, 0.0),
      flowRate: (json['flowRate'] as num?)?.toDouble() ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0,
      status: parseStatus((json['status'] as String?) ?? 'UNKNOWN'),
      isManual: (json['isManual'] as bool?) ?? false,
      tapOn: (json['tapOn'] as bool?) ?? ((json['flowRate'] as num?)?.toDouble() ?? 0) > 0,
      totalConsumed: (json['totalConsumed'] as num?)?.toDouble() ?? 0,
      updatedAt: DateTime.now(),
    );
  }
}
