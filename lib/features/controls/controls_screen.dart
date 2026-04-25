import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/frosted_card.dart';
import '../../core/widgets/section_header.dart';
import '../../state/flowit_controller.dart';
import '../../state/flowit_state.dart';

class ControlsScreen extends ConsumerWidget {
  const ControlsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flowitControllerProvider);
    final controller = ref.read(flowitControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.space16,
        AppConstants.space16,
        AppConstants.space16,
        AppConstants.space24,
      ),
      child: Column(
        children: [
          // Control Actions Card
          FrostedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Control Actions'),
                const SizedBox(height: AppConstants.space16),
                _ControlActionsGrid(
                  executingAction: state.executingAction,
                  onCalibrate: controller.calibrateSensor,
                  onReset: controller.resetDevice,
                  onStartFlow: controller.startFlow,
                  onStopFlow: controller.stopFlow,
                  onManualToggle: controller.toggleManualMode,
                ),
                if (state.executingAction) ...[
                  const SizedBox(height: AppConstants.space16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.space8),
                  Row(
                    children: [
                      const SizedBox(
                        width: AppConstants.iconSm,
                        height: AppConstants.iconSm,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.space8),
                      Text(
                        'Executing action...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppConstants.space16),

          // Detection Parameters Card
          FrostedCard(
            child: _ParamsEditor(
              params: state.params,
              onChanged: controller.updateParams,
              onApply: controller.pushParams,
              disabled: state.executingAction,
            ),
          ),
        ],
      ),
    );
  }
}

/// Control Actions Grid with responsive layout
class _ControlActionsGrid extends StatelessWidget {
  const _ControlActionsGrid({
    required this.executingAction,
    required this.onCalibrate,
    required this.onReset,
    required this.onStartFlow,
    required this.onStopFlow,
    required this.onManualToggle,
  });

  final bool executingAction;
  final VoidCallback onCalibrate;
  final VoidCallback onReset;
  final VoidCallback onStartFlow;
  final VoidCallback onStopFlow;
  final VoidCallback onManualToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine grid columns based on available width
        final int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        final double childAspectRatio = constraints.maxWidth > 600 ? 2.5 : 2.0;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppConstants.space12,
          mainAxisSpacing: AppConstants.space12,
          childAspectRatio: childAspectRatio,
          children: [
            _ControlButton(
              onPressed: executingAction ? null : onCalibrate,
              icon: Icons.tune,
              label: 'Calibrate',
              type: _ButtonType.primary,
            ),
            _ControlButton(
              onPressed: executingAction ? null : onReset,
              icon: Icons.restart_alt,
              label: 'Reset Device',
              type: _ButtonType.primary,
            ),
            _ControlButton(
              onPressed: executingAction ? null : onStartFlow,
              icon: Icons.play_arrow,
              label: 'Start Flow',
              type: _ButtonType.success,
            ),
            _ControlButton(
              onPressed: executingAction ? null : onStopFlow,
              icon: Icons.stop,
              label: 'Stop Flow',
              type: _ButtonType.danger,
            ),
            _ControlButton(
              onPressed: executingAction ? null : onManualToggle,
              icon: Icons.handyman_outlined,
              label: 'Manual Mode',
              type: _ButtonType.secondary,
            ),
          ],
        );
      },
    );
  }
}

/// Custom control button with modern styling
class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.type,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final _ButtonType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;

    // Get colors based on button type
    final colors = _getColors(type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Opacity(
          opacity: isDisabled ? AppConstants.opacityDisabled : 1.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDisabled
                    ? [
                        AppTheme.surfaceGrey,
                        AppTheme.surfaceGrey,
                      ]
                    : colors.gradient,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDisabled ? AppTheme.borderLight : colors.border,
                width: 1.5,
              ),
              boxShadow: isDisabled
                  ? []
                  : [
                      BoxShadow(
                        color: colors.gradient[0].withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isDisabled ? AppTheme.textTertiary : colors.iconColor,
                  size: AppConstants.iconMd,
                ),
                const SizedBox(height: AppConstants.space8),
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isDisabled ? AppTheme.textTertiary : colors.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _ButtonColors _getColors(_ButtonType type) {
    switch (type) {
      case _ButtonType.primary:
        return _ButtonColors(
          gradient: [AppTheme.primaryBlue, AppTheme.primaryBlueDark],
          border: AppTheme.primaryBlue,
          iconColor: Colors.white,
          textColor: Colors.white,
        );
      case _ButtonType.success:
        return _ButtonColors(
          gradient: [AppTheme.success, const Color(0xFF238276)],
          border: AppTheme.success,
          iconColor: Colors.white,
          textColor: Colors.white,
        );
      case _ButtonType.danger:
        return _ButtonColors(
          gradient: [AppTheme.error, const Color(0xFFD35940)],
          border: AppTheme.error,
          iconColor: Colors.white,
          textColor: Colors.white,
        );
      case _ButtonType.secondary:
        return _ButtonColors(
          gradient: [Colors.white, AppTheme.backgroundGreyLight],
          border: AppTheme.primaryBlue,
          iconColor: AppTheme.primaryBlue,
          textColor: AppTheme.primaryBlue,
        );
    }
  }
}

enum _ButtonType {
  primary,
  success,
  danger,
  secondary,
}

class _ButtonColors {
  const _ButtonColors({
    required this.gradient,
    required this.border,
    required this.iconColor,
    required this.textColor,
  });

  final List<Color> gradient;
  final Color border;
  final Color iconColor;
  final Color textColor;
}

/// Parameters Editor Widget
class _ParamsEditor extends StatefulWidget {
  const _ParamsEditor({
    required this.params,
    required this.onChanged,
    required this.onApply,
    required this.disabled,
  });

  final FlowItParams params;
  final ValueChanged<FlowItParams> onChanged;
  final Future<void> Function() onApply;
  final bool disabled;

  @override
  State<_ParamsEditor> createState() => _ParamsEditorState();
}

class _ParamsEditorState extends State<_ParamsEditor> {
  late FlowItParams _draft;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _draft = widget.params;
  }

  @override
  void didUpdateWidget(covariant _ParamsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.params != widget.params) {
      _draft = widget.params;
      _hasChanges = false;
    }
  }

  void _updateDraft(FlowItParams newDraft) {
    setState(() {
      _draft = newDraft;
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: SectionHeader(title: 'Detection Parameters'),
            ),
            if (_hasChanges)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.space8,
                  vertical: AppConstants.space4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      size: AppConstants.iconXs,
                      color: AppTheme.warning,
                    ),
                    const SizedBox(width: AppConstants.space4),
                    Text(
                      'Modified',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppConstants.space20),

        // Sliders
        _ModernSlider(
          label: 'Alignment Threshold',
          value: _draft.alignmentThreshold,
          min: 0,
          max: 1,
          onChanged: widget.disabled
              ? null
              : (v) => _updateDraft(_draft.copyWith(alignmentThreshold: v)),
          icon: Icons.center_focus_strong,
          color: AppTheme.primaryBlue,
        ),
        const SizedBox(height: AppConstants.space16),

        _ModernSlider(
          label: 'Rim Threshold',
          value: _draft.rimThreshold,
          min: 0,
          max: 1,
          onChanged: widget.disabled
              ? null
              : (v) => _updateDraft(_draft.copyWith(rimThreshold: v)),
          icon: Icons.radio_button_unchecked,
          color: AppTheme.accentBlue,
        ),
        const SizedBox(height: AppConstants.space16),

        _ModernSlider(
          label: 'Full Threshold',
          value: _draft.fullThreshold,
          min: 0,
          max: 1,
          onChanged: widget.disabled
              ? null
              : (v) => _updateDraft(_draft.copyWith(fullThreshold: v)),
          icon: Icons.check_circle_outline,
          color: AppTheme.success,
        ),
        const SizedBox(height: AppConstants.space16),

        _ModernSlider(
          label: 'Cluster Min Size',
          value: _draft.clusterMinSize.toDouble(),
          min: 1,
          max: 16,
          divisions: 15,
          onChanged: widget.disabled
              ? null
              : (v) => _updateDraft(_draft.copyWith(clusterMinSize: v.round())),
          icon: Icons.grid_on,
          color: AppTheme.info,
          isInteger: true,
        ),

        const SizedBox(height: AppConstants.space24),

        // Apply Button
        SizedBox(
          width: double.infinity,
          height: AppConstants.buttonHeightMd,
          child: FilledButton.icon(
            onPressed: widget.disabled || !_hasChanges
                ? null
                : () async {
                    widget.onChanged(_draft);
                    await widget.onApply();
                    if (mounted) {
                      setState(() => _hasChanges = false);
                    }
                  },
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('Apply Parameters'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              disabledBackgroundColor: AppTheme.surfaceGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              elevation: 2,
            ),
          ),
        ),

        if (!_hasChanges && !widget.disabled) ...[
          const SizedBox(height: AppConstants.space8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: AppConstants.iconXs,
                color: AppTheme.success,
              ),
              const SizedBox(width: AppConstants.space4),
              Text(
                'Parameters are up to date',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.success,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Modern slider with visual value indicator
class _ModernSlider extends StatelessWidget {
  const _ModernSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.icon,
    this.color,
    this.isInteger = false,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final int? divisions;
  final IconData? icon;
  final Color? color;
  final bool isInteger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onChanged == null;
    final effectiveColor = color ?? AppTheme.primaryBlue;
    final displayValue = isInteger ? value.round().toString() : value.toStringAsFixed(2);
    final percentage = ((value - min) / (max - min) * 100).clamp(0.0, 100.0);

    return Opacity(
      opacity: isDisabled ? AppConstants.opacityDisabled : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label and Value Row
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppConstants.iconSm,
                  color: isDisabled ? AppTheme.textTertiary : effectiveColor,
                ),
                const SizedBox(width: AppConstants.space8),
              ],
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDisabled ? AppTheme.textTertiary : AppTheme.textPrimary,
                  ),
                ),
              ),

              // Value Chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.space12,
                  vertical: AppConstants.space4,
                ),
                decoration: BoxDecoration(
                  color: isDisabled
                      ? AppTheme.surfaceGrey
                      : effectiveColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: isDisabled ? AppTheme.borderLight : effectiveColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  displayValue,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDisabled ? AppTheme.textTertiary : effectiveColor,
                    fontFeatures: const [
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space8),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: isDisabled ? AppTheme.borderMedium : effectiveColor,
              inactiveTrackColor: isDisabled
                  ? AppTheme.borderLight
                  : effectiveColor.withOpacity(0.2),
              thumbColor: isDisabled ? AppTheme.borderMedium : effectiveColor,
              overlayColor: effectiveColor.withOpacity(0.12),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 2,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 20,
              ),
              valueIndicatorColor: effectiveColor,
              valueIndicatorTextStyle: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),

          // Progress indicator bar
          const SizedBox(height: AppConstants.space4),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    color: isDisabled
                        ? AppTheme.borderLight
                        : effectiveColor.withOpacity(0.2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        gradient: LinearGradient(
                          colors: isDisabled
                              ? [AppTheme.borderMedium, AppTheme.borderMedium]
                              : [
                                  effectiveColor.withOpacity(0.6),
                                  effectiveColor,
                                ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.space8),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDisabled ? AppTheme.textTertiary : AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
