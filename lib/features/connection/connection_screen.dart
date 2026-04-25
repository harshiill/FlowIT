import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/frosted_card.dart';
import '../../core/widgets/flowit_logo.dart';
import '../../core/widgets/section_header.dart';
import '../../state/flowit_controller.dart';
import '../../state/flowit_state.dart';

class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConsumerState<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flowitControllerProvider);
    final notifier = ref.read(flowitControllerProvider.notifier);

    if (_controller.text.isEmpty) {
      _controller.text = state.baseUrl;
    }

    final label = switch (state.connectionState) {
      ConnectionStateX.connected => 'Connected',
      ConnectionStateX.connecting => 'Connecting',
      ConnectionStateX.reconnecting => 'Reconnecting',
      ConnectionStateX.disconnected => 'Disconnected',
    };

    final color = switch (state.connectionState) {
      ConnectionStateX.connected => const Color(0xFF2A9D8F),
      ConnectionStateX.connecting => const Color(0xFF4D96FF),
      ConnectionStateX.reconnecting => const Color(0xFFF4A261),
      ConnectionStateX.disconnected => const Color(0xFFE76F51),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: FlowItLogo(size: 22, style: FlowItLogoStyle.text),
          ),
          const SizedBox(height: 12),
          FrostedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Device Connection'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: color),
                    const SizedBox(width: 8),
                    Text(label, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'ESP32 Base URL',
                    hintText: 'http://192.168.4.1',
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: () => notifier.setBaseUrl(_controller.text),
                      icon: const Icon(Icons.wifi),
                      label: const Text('Connect via WiFi'),
                    ),
                    OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.bluetooth),
                      label: const Text('Bluetooth (Optional)'),
                    ),
                  ],
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          FrostedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'How to Connect'),
                const SizedBox(height: 10),
                _InstructionStep(
                  number: '1',
                  title: 'Power on your FlowIt device',
                  description: 'Make sure the ESP32 board is turned on and running FlowIt firmware.',
                ),
                const SizedBox(height: 10),
                _InstructionStep(
                  number: '2',
                  title: 'Join the same WiFi network',
                  description: 'Connect your phone to the same WiFi network as the ESP32.',
                ),
                const SizedBox(height: 10),
                _InstructionStep(
                  number: '3',
                  title: 'Find the ESP32 IP address',
                  description: 'Check your WiFi router or ESP32 display for the device IP (usually 192.168.x.x)',
                ),
                const SizedBox(height: 10),
                _InstructionStep(
                  number: '4',
                  title: 'Enter the URL above',
                  description: 'Type http://[IP_ADDRESS] in the URL field and tap "Connect via WiFi"',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  const _InstructionStep({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.75),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
