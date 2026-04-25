import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../state/flowit_state.dart';

class AlertsList extends StatelessWidget {
  const AlertsList({super.key, required this.alerts});

  final List<AlertEvent> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Text('No alerts yet', style: Theme.of(context).textTheme.bodyMedium);
    }

    return Column(
      children: alerts
          .take(4)
          .map(
            (alert) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _color(alert.type).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _color(alert.type).withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(_icon(alert.type), size: 18, color: _color(alert.type)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(alert.message, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 8),
                  Text(DateFormat('HH:mm').format(alert.timestamp), style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Color _color(AlertType type) {
    switch (type) {
      case AlertType.warning:
        return const Color(0xFFE76F51);
      case AlertType.success:
        return const Color(0xFF2A9D8F);
      case AlertType.info:
        return const Color(0xFF4D96FF);
    }
  }

  IconData _icon(AlertType type) {
    switch (type) {
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.success:
        return Icons.task_alt;
      case AlertType.info:
        return Icons.info_outline;
    }
  }
}
