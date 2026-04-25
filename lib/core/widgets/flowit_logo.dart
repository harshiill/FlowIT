import 'package:flutter/material.dart';

import '../theme/app_constants.dart';
import '../theme/app_theme.dart';

/// FlowIt brand logo component with multiple style variants
///
/// Displays the FlowIt logo in different formats:
/// - [FlowItLogoStyle.text]: Logo image + text
/// - [FlowItLogoStyle.icon]: Logo image only
/// - [FlowItLogoStyle.badge]: Logo with badge background
///
/// Uses design system constants for consistent sizing and spacing.
class FlowItLogo extends StatelessWidget {
  const FlowItLogo({
    super.key,
    this.size = 32,
    this.style = FlowItLogoStyle.text,
    this.color,
  });

  /// Size of the logo (affects image and text)
  final double size;

  /// Display style variant
  final FlowItLogoStyle style;

  /// Custom text color (overrides default)
  final Color? color;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case FlowItLogoStyle.text:
        return _buildTextVariant(context);
      case FlowItLogoStyle.icon:
        return _buildIconVariant();
      case FlowItLogoStyle.badge:
        return _buildBadgeVariant(context);
    }
  }

  /// Logo image with text label
  Widget _buildTextVariant(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? AppTheme.textPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _LogoImage(size: size),
        SizedBox(width: size * 0.3),
        Text(
          'FlowIt',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: size * 0.85,
            color: effectiveColor,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
      ],
    );
  }

  /// Logo image only
  Widget _buildIconVariant() {
    return _LogoImage(size: size);
  }

  /// Logo in a badge container with background
  Widget _buildBadgeVariant(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? AppTheme.textPrimary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.5,
        vertical: size * 0.3,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accentBluePale,
        borderRadius: BorderRadius.circular(size * 0.5),
        border: Border.all(
          color: AppTheme.primaryBlue,
          width: 1.5,
        ),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LogoImage(size: size * 0.8),
          SizedBox(width: size * 0.35),
          Text(
            'FlowIt',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: size * 0.7,
              color: effectiveColor,
              letterSpacing: -0.3,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo variants for different use cases
enum FlowItLogoStyle {
  /// Logo image with text label (default)
  text,

  /// Logo image only
  icon,

  /// Logo with badge background
  badge,
}

/// Internal widget for rendering the logo image asset
class _LogoImage extends StatelessWidget {
  const _LogoImage({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.asset(
          'logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

/// Horizontal logo with separator for app bars
class FlowItLogoWithSeparator extends StatelessWidget {
  const FlowItLogoWithSeparator({
    super.key,
    this.size = 24,
    this.showSeparator = true,
  });

  final double size;
  final bool showSeparator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlowItLogo(size: size, style: FlowItLogoStyle.text),
        if (showSeparator) ...[
          SizedBox(width: AppConstants.space16),
          Container(
            height: size * 1.2,
            width: 1,
            color: AppTheme.borderLight,
          ),
        ],
      ],
    );
  }
}

/// Animated logo for splash screens
class AnimatedFlowItLogo extends StatefulWidget {
  const AnimatedFlowItLogo({
    super.key,
    this.size = 64,
    this.style = FlowItLogoStyle.text,
  });

  final double size;
  final FlowItLogoStyle style;

  @override
  State<AnimatedFlowItLogo> createState() => _AnimatedFlowItLogoState();
}

class _AnimatedFlowItLogoState extends State<AnimatedFlowItLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FlowItLogo(
          size: widget.size,
          style: widget.style,
        ),
      ),
    );
  }
}
