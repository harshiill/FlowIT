import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          FrostedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Control Actions'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: state.executingAction ? null : controller.calibrateSensor,
                      icon: const Icon(Icons.tune),
                      label: const Text('Calibrate Sensor'),
                    ),
                    FilledButton.icon(
                      onPressed: state.executingAction ? null : controller.resetDevice,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reset ESP Device'),
                    ),
                    FilledButton.icon(
                      onPressed: state.executingAction ? null : controller.startFlow,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Flow'),
                    ),
                    FilledButton.icon(
                      onPressed: state.executingAction ? null : controller.stopFlow,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop Flow'),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.executingAction ? null : controller.toggleManualMode,
                      icon: const Icon(Icons.handyman_outlined),
                      label: const Text('Manual Toggle'),
                    ),
                  ],
                ),
                if (state.executingAction) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(minHeight: 3),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Detection Parameters'),
        const SizedBox(height: 14),
        _SliderRow(
          label: 'Alignment threshold',
          value: _draft.alignmentThreshold,
          min: 0,
          max: 1,
          onChanged: (v) => setState(() => _draft = _draft.copyWith(alignmentThreshold: v)),
        ),
        _SliderRow(
          label: 'Rim threshold',
          value: _draft.rimThreshold,
          min: 0,
          max: 1,
          onChanged: (v) => setState(() => _draft = _draft.copyWith(rimThreshold: v)),
        ),
        _SliderRow(
          label: 'Full threshold',
          value: _draft.fullThreshold,
          min: 0,
          max: 1,
          onChanged: (v) => setState(() => _draft = _draft.copyWith(fullThreshold: v)),
        ),
        _SliderRow(
          label: 'Cluster min size',
          value: _draft.clusterMinSize.toDouble(),
          min: 1,
          max: 16,
          divisions: 15,
          onChanged: (v) => setState(() => _draft = _draft.copyWith(clusterMinSize: v.round())),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: widget.disabled
              ? null
              : () async {
                  widget.onChanged(_draft);
                  await widget.onApply();
                },
          icon: const Icon(Icons.cloud_upload_outlined),
          label: const Text('Apply Parameters'),
        ),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(value.toStringAsFixed(2), style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
