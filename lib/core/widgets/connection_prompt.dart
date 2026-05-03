import 'package:flutter/material.dart';

import '../../state/flowit_state.dart';
import '../theme/app_constants.dart';
import '../theme/app_theme.dart';
import 'flowit_logo.dart';

/// Modern connection prompt shown when device is not connected
///
/// Displays different states based on connection status:
/// - Disconnected: Call to action to configure connection
/// - Connecting: Loading indicator with message
/// - Error: Error details with retry option
///
/// Uses modern design with animations and clear visual hierarchy.
class ConnectionPrompt extends StatelessWidget {
  const ConnectionPrompt({
    super.key,
    required this.connectionState,
    required this.errorMessage,
    required this.onGoToConnection,
    this.onLongPressLogo,
  });

  final ConnectionStateX connectionState;
  final String? errorMessage;
  final VoidCallback onGoToConnection;
  final VoidCallback? onLongPressLogo;

  @override
  Widget build(BuildContext context) {
    final isDisconnected = connectionState == ConnectionStateX.disconnected || errorMessage != null;
    final isConnecting = connectionState == ConnectionStateX.connecting ||
                        connectionState == ConnectionStateX.reconnecting;

    if (!isDisconnected && !isConnecting) {
      return const SizedBox.shrink();
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onLongPress: onLongPressLogo,
              child: _buildLogo(context, isConnecting),
            ),
            const SizedBox(height: AppConstants.space32),
            _buildContent(context, isConnecting),
          ],
        ),
      ),
    );
  }

  /// Build animated logo
  Widget _buildLogo(BuildContext context, bool isConnecting) {
    if (isConnecting) {
      return _AnimatedConnectingLogo();
    }

    return const AnimatedFlowItLogo(
      size: 64,
      style: FlowItLogoStyle.icon,
    );
  }

  /// Build main content area
  Widget _buildContent(BuildContext context, bool isConnecting) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.all(AppConstants.space24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusIcon(isConnecting),
          const SizedBox(height: AppConstants.space20),
          _buildTitle(context, isConnecting),
          const SizedBox(height: AppConstants.space12),
          _buildDescription(context, isConnecting),
          if (errorMessage != null && !isConnecting) ...[
            const SizedBox(height: AppConstants.space20),
            _buildErrorMessage(context),
          ],
          const SizedBox(height: AppConstants.space24),
          _buildActionButton(context, isConnecting),
          const SizedBox(height: AppConstants.space16),
          _buildHelpText(context),
        ],
      ),
    );
  }

  /// Build status icon
  Widget _buildStatusIcon(bool isConnecting) {
    if (isConnecting) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.info.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.info),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.cloud_off_outlined,
        size: 32,
        color: AppTheme.error,
      ),
    );
  }

  /// Build title text
  Widget _buildTitle(BuildContext context, bool isConnecting) {
    final theme = Theme.of(context);
    final title = isConnecting ? 'Connecting to Device' : 'Not Connected';

    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build description text
  Widget _buildDescription(BuildContext context, bool isConnecting) {
    final theme = Theme.of(context);
    final description = isConnecting
        ? 'Waiting for ESP32 device response...'
        : 'Please configure your ESP32 connection to access your FlowIt dashboard.';

    return Text(
      description,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build error message container
  Widget _buildErrorMessage(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppTheme.errorLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: AppTheme.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppTheme.error,
            size: AppConstants.iconMd,
          ),
          const SizedBox(width: AppConstants.space12),
          Expanded(
            child: Text(
              errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.error,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build action button
  Widget _buildActionButton(BuildContext context, bool isConnecting) {
    if (isConnecting) {
      return OutlinedButton.icon(
        onPressed: onGoToConnection,
        icon: const Icon(Icons.settings_outlined, size: AppConstants.iconSm),
        label: const Text('Connection Settings'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space24,
            vertical: AppConstants.space16,
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onGoToConnection,
      icon: const Icon(Icons.settings_outlined, size: AppConstants.iconSm),
      label: const Text('Configure Connection'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space24,
          vertical: AppConstants.space16,
        ),
        minimumSize: const Size(double.infinity, 52),
      ),
    );
  }

  /// Build help text
  Widget _buildHelpText(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.space12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBlue,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: AppConstants.iconSm,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: AppConstants.space8),
          Expanded(
            child: Text(
              'Make sure your ESP32 is powered on and running FlowIt firmware.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated logo for connecting state
class _AnimatedConnectingLogo extends StatefulWidget {
  @override
  State<_AnimatedConnectingLogo> createState() => _AnimatedConnectingLogoState();
}

class _AnimatedConnectingLogoState extends State<_AnimatedConnectingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.space12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const FlowItLogo(
          size: 48,
          style: FlowItLogoStyle.icon,
        ),
      ),
    );
  }
}

/// Compact connection prompt for inline usage
class CompactConnectionPrompt extends StatelessWidget {
  const CompactConnectionPrompt({
    super.key,
    required this.onGoToConnection,
    this.message = 'Device not connected',
  });

  final VoidCallback onGoToConnection;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppTheme.warningLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: AppTheme.warning.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.warning,
            size: AppConstants.iconMd,
          ),
          const SizedBox(width: AppConstants.space12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.space12),
          TextButton(
            onPressed: onGoToConnection,
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }
}
