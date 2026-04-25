import 'package:flutter/material.dart';

import '../../state/flowit_state.dart';
import 'flowit_logo.dart';

class ConnectionPrompt extends StatelessWidget {
  const ConnectionPrompt({
    super.key,
    required this.connectionState,
    required this.errorMessage,
    required this.onGoToConnection,
  });

  final ConnectionStateX connectionState;
  final String? errorMessage;
  final VoidCallback onGoToConnection;

  @override
  Widget build(BuildContext context) {
    final isDisconnected = connectionState == ConnectionStateX.disconnected || errorMessage != null;
    final isConnecting = connectionState == ConnectionStateX.connecting || connectionState == ConnectionStateX.reconnecting;

    if (!isDisconnected && !isConnecting) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FlowItLogo(size: 48, style: FlowItLogoStyle.icon),
          const SizedBox(height: 24),
          Text(
            isConnecting ? 'Connecting to ESP32...' : 'Not Connected',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            isConnecting
                ? 'Waiting for device response'
                : 'Please configure your ESP32 connection to continue.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (errorMessage != null && !isConnecting) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onGoToConnection,
            icon: const Icon(Icons.settings),
            label: const Text('Go to Connection Settings'),
          ),
          const SizedBox(height: 16),
          Text(
            'Make sure your ESP32 is powered on and running FlowIt firmware.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}
