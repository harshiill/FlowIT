import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_constants.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppConstants.space8,
          runSpacing: AppConstants.space8,
          children: [
            _StatusChip(label: status.label, color: status.color),
            _StatusChip(
              label: tapOn ? 'Tap ON' : 'Tap OFF',
              color: tapOn ? AppTheme.success : AppTheme.textTertiary,
              icon: tapOn ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            ),
            _StatusChip(
              label: aligned ? 'Aligned' : 'Misaligned',
              color: aligned ? AppTheme.success : AppTheme.error,
              icon: aligned ? Icons.done_all_rounded : Icons.warning_amber_rounded,
            ),
          ],
        ),
        if (connectionState == ConnectionStateX.disconnected) ...[
          const SizedBox(height: AppConstants.space8),
          _StatusChip(
            label: connectionLabel,
            color: _getConnectionColor(connectionState),
            icon: _getConnectionIcon(connectionState),
            isAnimating: false,
          ),
        ] else ...[
          const SizedBox(height: AppConstants.space8),
          _StatusChip(
            label: connectionLabel,
            color: _getConnectionColor(connectionState),
            icon: _getConnectionIcon(connectionState),
            isAnimating: connectionState == ConnectionStateX.connecting ||
                connectionState == ConnectionStateX.reconnecting,
          ),
        ],
      ],
    );
  }

  Color _getConnectionColor(ConnectionStateX state) {
    return switch (state) {
      ConnectionStateX.connected => AppTheme.success,
      ConnectionStateX.connecting => AppTheme.info,
      ConnectionStateX.reconnecting => AppTheme.warning,
      ConnectionStateX.disconnected => AppTheme.textTertiary,
    };
  }

  IconData _getConnectionIcon(ConnectionStateX state) {
    return switch (state) {
      ConnectionStateX.connected => Icons.wifi_rounded,
      ConnectionStateX.connecting => Icons.sync_rounded,
      ConnectionStateX.reconnecting => Icons.sync_problem_rounded,
      ConnectionStateX.disconnected => Icons.wifi_off_rounded,
    };
  }
}

class _StatusChip extends StatefulWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    this.icon,
    this.isAnimating = false,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool isAnimating;

  @override
  State<_StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<_StatusChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: AppConstants.durationVerySlow * 2,
      vsync: this,
    );

    if (widget.isAnimating) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(_StatusChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _rotationController.repeat();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _rotationController.stop();
      _rotationController.reset();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.durationNormal,
        curve: AppConstants.animationCurve,
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.space12,
          vertical: AppConstants.space8,
        ),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(AppConstants.opacitySelected),
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(
            color: widget.color.withOpacity(_isHovered ? 0.6 : 0.4),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              widget.isAnimating
                  ? RotationTransition(
                      turns: _rotationController,
                      child: Icon(
                        widget.icon,
                        size: AppConstants.iconXs,
                        color: widget.color,
                      ),
                    )
                  : Icon(
                      widget.icon,
                      size: AppConstants.iconXs,
                      color: widget.color,
                    ),
              SizedBox(width: AppConstants.space4),
            ],
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: widget.color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
