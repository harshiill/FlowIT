import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/frosted_card.dart';
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
        ],
      ),
    );
  }
}
