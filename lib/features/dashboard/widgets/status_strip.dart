import 'package:flutter/material.dart';

import '../../../data/models/device_data.dart';
import '../../../state/flowit_state.dart';

class StatusStrip extends StatelessWidget {
  const StatusStrip({
    super.key,
    required this.status,
    required this.tapOn,
    required this.connectionState,
    required this.aligned,
  });

  final DeviceStatus status;
  final bool tapOn;
  final ConnectionStateX connectionState;
  final bool aligned;

  @override
  Widget build(BuildContext context) {
    final connectionLabel = switch (connectionState) {
      ConnectionStateX.connected => 'Connected',
      ConnectionStateX.connecting => 'Connecting',
      ConnectionStateX.reconnecting => 'Reconnecting',
      ConnectionStateX.disconnected => 'Disconnected',
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Chip(label: status.label, color: status.color),
        _Chip(label: tapOn ? 'Tap ON' : 'Tap OFF', color: tapOn ? const Color(0xFF2A9D8F) : const Color(0xFF9AA0A6)),
        _Chip(label: aligned ? 'Aligned' : 'Misaligned', color: aligned ? const Color(0xFF0A9396) : const Color(0xFFE76F51)),
        _Chip(label: connectionLabel, color: const Color(0xFF4D96FF)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}
