import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_constants.dart';
import '../../../state/flowit_state.dart';

class AlertsList extends StatelessWidget {
  const AlertsList({super.key, required this.alerts});

  final List<AlertEvent> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return _EmptyAlertsState();
    }

    return Column(
      children: alerts
          .take(AppConstants.maxAlertsDisplay)
          .map((alert) => _AlertItem(alert: alert))
          .toList(growable: false),
    );
  }
}

class _EmptyAlertsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.space24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: AppConstants.iconMd,
            color: AppTheme.textTertiary,
          ),
          SizedBox(width: AppConstants.space12),
          Text(
            'No alerts yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _AlertItem extends StatefulWidget {
  const _AlertItem({required this.alert});

  final AlertEvent alert;

  @override
  State<_AlertItem> createState() => _AlertItemState();
}

class _AlertItemState extends State<_AlertItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.durationNormal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppConstants.animationCurveEaseOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppConstants.animationCurveEaseOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getColor(AlertType type) {
    return switch (type) {
      AlertType.warning => AppTheme.error,
      AlertType.success => AppTheme.success,
      AlertType.info => AppTheme.info,
    };
  }

  Color _getBackgroundColor(AlertType type) {
    return switch (type) {
      AlertType.warning => AppTheme.errorLight,
      AlertType.success => AppTheme.successLight,
      AlertType.info => AppTheme.infoLight,
    };
  }

  IconData _getIcon(AlertType type) {
    return switch (type) {
      AlertType.warning => Icons.warning_amber_rounded,
      AlertType.success => Icons.check_circle_rounded,
      AlertType.info => Icons.info_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(widget.alert.type);
    final backgroundColor = _getBackgroundColor(widget.alert.type);
    final icon = _getIcon(widget.alert.type);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: AppConstants.durationFast,
            curve: AppConstants.animationCurve,
            margin: EdgeInsets.only(bottom: AppConstants.space8),
            padding: EdgeInsets.all(AppConstants.space12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: color.withOpacity(_isHovered ? 0.6 : 0.3),
                width: _isHovered ? 1.5 : 1.0,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(AppConstants.space4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    size: AppConstants.iconSm,
                    color: color,
                  ),
                ),
                SizedBox(width: AppConstants.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.alert.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                      ),
                      SizedBox(height: AppConstants.space4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: AppConstants.iconXs - 2,
                            color: AppTheme.textTertiary,
                          ),
                          SizedBox(width: AppConstants.space4),
                          Text(
                            DateFormat('HH:mm:ss').format(widget.alert.timestamp),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.textTertiary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppConstants.space8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.space8,
                    vertical: AppConstants.space4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(
                    _getTypeLabel(widget.alert.type),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(AlertType type) {
    return switch (type) {
      AlertType.warning => 'WARN',
      AlertType.success => 'OK',
      AlertType.info => 'INFO',
    };
  }
}
