import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_constants.dart';
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

    final connectionStatus = _getConnectionStatus(state.connectionState);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.space16,
        AppConstants.space16,
        AppConstants.space16,
        AppConstants.space24,
      ),
      child: Column(
        children: [
          // Logo
          const Align(
            alignment: Alignment.centerLeft,
            child: FlowItLogo(size: 22, style: FlowItLogoStyle.text),
          ),
          const SizedBox(height: AppConstants.space16),

          // Connection Card
          FrostedCard(
            elevation: CardElevation.medium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Device Connection',
                  size: SectionHeaderSize.medium,
                ),
                const SizedBox(height: AppConstants.space16),

                // Connection Status Indicator
                _ConnectionStatusIndicator(
                  label: connectionStatus.label,
                  color: connectionStatus.color,
                  icon: connectionStatus.icon,
                ),
                const SizedBox(height: AppConstants.space20),

                // URL Input Field
                _StyledTextField(
                  controller: _controller,
                  labelText: 'ESP32 Base URL',
                  hintText: 'http://192.168.4.1',
                  prefixIcon: Icons.link_rounded,
                ),
                const SizedBox(height: AppConstants.space16),

                // Connection Buttons
                Wrap(
                  spacing: AppConstants.space12,
                  runSpacing: AppConstants.space12,
                  children: [
                    FilledButton.icon(
                      onPressed: () => notifier.setBaseUrl(_controller.text),
                      icon: const Icon(Icons.wifi_rounded, size: AppConstants.iconSm),
                      label: const Text('Connect via WiFi'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: AppTheme.textOnPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.space20,
                          vertical: AppConstants.space12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.bluetooth_rounded, size: AppConstants.iconSm),
                      label: const Text('Bluetooth (Soon)'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.space20,
                          vertical: AppConstants.space12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        ),
                      ),
                    ),
                  ],
                ),

                // Error Message
                if (state.errorMessage != null) ...[
                  const SizedBox(height: AppConstants.space16),
                  _ErrorMessage(message: state.errorMessage!),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppConstants.space16),

          // Instructions Card
          FrostedCard(
            elevation: CardElevation.low,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeaderWithIcon(
                  title: 'How to Connect',
                  icon: Icons.help_outline_rounded,
                  iconColor: AppTheme.info,
                  iconBackgroundColor: AppTheme.infoLight,
                  size: SectionHeaderSize.medium,
                ),
                const SizedBox(height: AppConstants.space16),

                _InstructionStep(
                  number: 1,
                  title: 'Power on your FlowIt device',
                  description: 'Make sure the ESP32 board is turned on and running FlowIt firmware.',
                  icon: Icons.power_settings_new_rounded,
                ),
                const SizedBox(height: AppConstants.space12),

                _InstructionStep(
                  number: 2,
                  title: 'Join the same WiFi network',
                  description: 'Connect your phone to the same WiFi network as the ESP32.',
                  icon: Icons.wifi_rounded,
                ),
                const SizedBox(height: AppConstants.space12),

                _InstructionStep(
                  number: 3,
                  title: 'Find the ESP32 IP address',
                  description: 'Check your WiFi router or ESP32 display for the device IP (usually 192.168.x.x)',
                  icon: Icons.router_rounded,
                ),
                const SizedBox(height: AppConstants.space12),

                _InstructionStep(
                  number: 4,
                  title: 'Enter the URL above',
                  description: 'Type http://[IP_ADDRESS] in the URL field and tap "Connect via WiFi"',
                  icon: Icons.touch_app_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _ConnectionStatusData _getConnectionStatus(ConnectionStateX connectionState) {
    switch (connectionState) {
      case ConnectionStateX.connected:
        return const _ConnectionStatusData(
          label: 'Connected',
          color: AppTheme.success,
          icon: Icons.check_circle_rounded,
        );
      case ConnectionStateX.connecting:
        return const _ConnectionStatusData(
          label: 'Connecting',
          color: AppTheme.info,
          icon: Icons.sync_rounded,
        );
      case ConnectionStateX.reconnecting:
        return const _ConnectionStatusData(
          label: 'Reconnecting',
          color: AppTheme.warning,
          icon: Icons.refresh_rounded,
        );
      case ConnectionStateX.disconnected:
        return const _ConnectionStatusData(
          label: 'Disconnected',
          color: AppTheme.error,
          icon: Icons.cancel_rounded,
        );
    }
  }
}

// ==================== WIDGETS ====================

/// Connection status indicator with icon and label
class _ConnectionStatusIndicator extends StatelessWidget {
  const _ConnectionStatusIndicator({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space16,
        vertical: AppConstants.space12,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppConstants.iconSm, color: color),
          const SizedBox(width: AppConstants.space12),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Styled text field with modern design
class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.url,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, size: AppConstants.iconSm),
        filled: true,
        fillColor: AppTheme.surfaceGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppTheme.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppTheme.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space16,
          vertical: AppConstants.space16,
        ),
      ),
    );
  }
}

/// Error message display
class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.space12),
      decoration: BoxDecoration(
        color: AppTheme.errorLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(
          color: AppTheme.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: AppConstants.iconSm,
            color: AppTheme.error,
          ),
          const SizedBox(width: AppConstants.space12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Instruction step with number, icon, title and description
class _InstructionStep extends StatelessWidget {
  const _InstructionStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  final int number;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.space12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBlue,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: AppTheme.accentBluePale,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge with gradient
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.primaryBlueLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textOnPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.space12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: AppConstants.iconSm,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(width: AppConstants.space8),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.space4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== DATA CLASSES ====================

/// Connection status data
class _ConnectionStatusData {
  const _ConnectionStatusData({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}
