import 'package:flutter/material.dart';

import '../theme/app_constants.dart';
import '../theme/app_theme.dart';

/// Modern section header with title and optional actions
///
/// Used to separate content sections in screens with clear visual hierarchy.
/// Supports trailing actions, subtitles, and different size variants.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.size = SectionHeaderSize.medium,
    this.showDivider = false,
    this.padding,
    this.onTap,
  });

  /// Section title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional trailing widget (e.g., button, icon, text)
  final Widget? trailing;

  /// Size variant of the header
  final SectionHeaderSize size;

  /// Whether to show a divider below the header
  final bool showDivider;

  /// Custom padding (overrides default)
  final EdgeInsetsGeometry? padding;

  /// Callback when header is tapped (makes entire header tappable)
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyles = _getTextStyles(theme, size);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Expanded(
              child: Text(
                title,
                style: textStyles.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Trailing widget
            if (trailing != null) ...[
              const SizedBox(width: AppConstants.space12),
              trailing!,
            ],
          ],
        ),

        // Subtitle
        if (subtitle != null) ...[
          const SizedBox(height: AppConstants.space4),
          Text(
            subtitle!,
            style: textStyles.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        // Divider
        if (showDivider) ...[
          const SizedBox(height: AppConstants.space12),
          const Divider(height: 1),
        ],
      ],
    );

    // Make tappable if onTap is provided
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: content,
        ),
      );
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: content,
    );
  }

  _SectionHeaderTextStyles _getTextStyles(ThemeData theme, SectionHeaderSize size) {
    switch (size) {
      case SectionHeaderSize.small:
        return _SectionHeaderTextStyles(
          title: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
          subtitle: theme.textTheme.bodySmall!.copyWith(
            color: AppTheme.textTertiary,
          ),
        );
      case SectionHeaderSize.medium:
        return _SectionHeaderTextStyles(
          title: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
          subtitle: theme.textTheme.bodySmall!.copyWith(
            color: AppTheme.textTertiary,
          ),
        );
      case SectionHeaderSize.large:
        return _SectionHeaderTextStyles(
          title: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
          subtitle: theme.textTheme.bodyMedium!.copyWith(
            color: AppTheme.textSecondary,
          ),
        );
    }
  }
}

/// Section header with action button
class SectionHeaderWithAction extends StatelessWidget {
  const SectionHeaderWithAction({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onActionPressed,
    this.subtitle,
    this.size = SectionHeaderSize.medium,
    this.actionIcon,
  });

  final String title;
  final String? subtitle;
  final String actionLabel;
  final VoidCallback onActionPressed;
  final SectionHeaderSize size;
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    return SectionHeader(
      title: title,
      subtitle: subtitle,
      size: size,
      trailing: TextButton.icon(
        onPressed: onActionPressed,
        icon: actionIcon != null ? Icon(actionIcon, size: AppConstants.iconSm) : const SizedBox.shrink(),
        label: Text(actionLabel),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space12,
            vertical: AppConstants.space8,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

/// Section header with icon
class SectionHeaderWithIcon extends StatelessWidget {
  const SectionHeaderWithIcon({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
    this.size = SectionHeaderSize.medium,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final SectionHeaderSize size;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppTheme.primaryBlue;
    final effectiveBgColor = iconBackgroundColor ?? AppTheme.primaryBlue.withOpacity(0.12);
    final iconSize = size == SectionHeaderSize.large ? 24.0 : 20.0;
    final containerSize = size == SectionHeaderSize.large ? 40.0 : 32.0;

    return Row(
      children: [
        // Icon container
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: effectiveIconColor,
          ),
        ),
        const SizedBox(width: AppConstants.space12),

        // Header
        Expanded(
          child: SectionHeader(
            title: title,
            subtitle: subtitle,
            size: size,
            trailing: trailing,
          ),
        ),
      ],
    );
  }
}

/// Minimalist section header with just text
class SimpleSectionHeader extends StatelessWidget {
  const SimpleSectionHeader({
    super.key,
    required this.title,
    this.color,
  });

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: color ?? AppTheme.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

/// Section header with badge/count
class SectionHeaderWithBadge extends StatelessWidget {
  const SectionHeaderWithBadge({
    super.key,
    required this.title,
    required this.count,
    this.subtitle,
    this.trailing,
    this.size = SectionHeaderSize.medium,
    this.badgeColor,
  });

  final String title;
  final int count;
  final String? subtitle;
  final Widget? trailing;
  final SectionHeaderSize size;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBadgeColor = badgeColor ?? AppTheme.primaryBlue;

    return SectionHeader(
      title: title,
      subtitle: subtitle,
      size: size,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space8,
              vertical: AppConstants.space4,
            ),
            decoration: BoxDecoration(
              color: effectiveBadgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: Text(
              count.toString(),
              style: theme.textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: effectiveBadgeColor,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppConstants.space8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

// ==================== ENUMS & DATA CLASSES ====================

/// Size variants for section headers
enum SectionHeaderSize {
  small,
  medium,
  large,
}

/// Internal class for section header text styles
class _SectionHeaderTextStyles {
  const _SectionHeaderTextStyles({
    required this.title,
    required this.subtitle,
  });

  final TextStyle title;
  final TextStyle subtitle;
}
