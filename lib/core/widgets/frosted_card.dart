import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_constants.dart';
import '../theme/app_theme.dart';

/// Modern glassmorphic card with frosted backdrop effect
///
/// Provides a premium look with blur effect, soft shadows, and subtle borders.
/// Perfect for IoT dashboard cards and content containers.
class FrostedCard extends StatelessWidget {
  const FrostedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation = CardElevation.medium,
    this.blurIntensity = 12.0,
    this.showBorder = true,
    this.backgroundColor,
    this.borderColor,
  });

  /// The widget below this widget in the tree
  final Widget child;

  /// Internal padding of the card. Defaults to [AppConstants.space16]
  final EdgeInsetsGeometry? padding;

  /// External margin of the card. Defaults to [EdgeInsets.zero]
  final EdgeInsetsGeometry? margin;

  /// Border radius. Defaults to [AppConstants.radiusXl]
  final BorderRadius? borderRadius;

  /// Shadow elevation level
  final CardElevation elevation;

  /// Blur intensity for the backdrop filter (sigma value)
  final double blurIntensity;

  /// Whether to show the border
  final bool showBorder;

  /// Custom background color (overrides theme color)
  final Color? backgroundColor;

  /// Custom border color (overrides default)
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePadding = padding ?? const EdgeInsets.all(AppConstants.space16);
    final effectiveMargin = margin ?? EdgeInsets.zero;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppConstants.radiusXl);
    final effectiveBackgroundColor = backgroundColor ?? theme.cardTheme.color ?? AppTheme.surfaceWhite;
    final effectiveBorderColor = borderColor ?? AppTheme.borderLight;

    // Get shadow based on elevation
    final shadow = _getShadow(elevation);

    return Container(
      margin: effectiveMargin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: shadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              borderRadius: effectiveBorderRadius,
              border: showBorder
                  ? Border.all(
                      color: effectiveBorderColor,
                      width: 1.0,
                    )
                  : null,
            ),
            padding: effectivePadding,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Returns appropriate shadow based on elevation level
  List<BoxShadow> _getShadow(CardElevation level) {
    switch (level) {
      case CardElevation.none:
        return [];
      case CardElevation.low:
        return AppTheme.shadowSm;
      case CardElevation.medium:
        return AppTheme.shadowMd;
      case CardElevation.high:
        return AppTheme.shadowLg;
      case CardElevation.extraHigh:
        return AppTheme.shadowXl;
    }
  }
}

/// Elevation levels for cards
enum CardElevation {
  none,
  low,
  medium,
  high,
  extraHigh,
}

/// Compact variant of FrostedCard with reduced padding
class CompactFrostedCard extends StatelessWidget {
  const CompactFrostedCard({
    super.key,
    required this.child,
    this.margin,
    this.borderRadius,
    this.elevation = CardElevation.low,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final CardElevation elevation;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(AppConstants.space12),
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      child: child,
    );
  }
}

/// Large variant of FrostedCard with increased padding
class LargeFrostedCard extends StatelessWidget {
  const LargeFrostedCard({
    super.key,
    required this.child,
    this.margin,
    this.borderRadius,
    this.elevation = CardElevation.medium,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final CardElevation elevation;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(AppConstants.space24),
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      child: child,
    );
  }
}

/// Outlined variant without frosted effect
class OutlinedCard extends StatelessWidget {
  const OutlinedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePadding = padding ?? const EdgeInsets.all(AppConstants.space16);
    final effectiveMargin = margin ?? EdgeInsets.zero;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppConstants.radiusLg);
    final effectiveBackgroundColor = backgroundColor ?? theme.cardTheme.color ?? AppTheme.surfaceWhite;
    final effectiveBorderColor = borderColor ?? AppTheme.borderMedium;

    return Container(
      margin: effectiveMargin,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}
