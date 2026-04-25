import 'package:flutter/animation.dart';

/// FlowIt App Constants
/// Contains spacing, sizing, duration, and other constant values
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ==================== SPACING ====================

  /// Base spacing unit (8px grid system)
  static const double spaceUnit = 8.0;

  /// Spacing scale
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space36 = 36.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;

  // ==================== BORDER RADIUS ====================

  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 999.0;

  // ==================== SIZING ====================

  /// Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;

  /// Button heights
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 44.0;
  static const double buttonHeightLg = 52.0;

  /// Avatar sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 72.0;

  /// Logo sizes
  static const double logoSm = 24.0;
  static const double logoMd = 32.0;
  static const double logoLg = 48.0;
  static const double logoXl = 64.0;

  /// Card min heights
  static const double cardMinHeight = 100.0;
  static const double metricTileHeight = 80.0;

  // ==================== ANIMATION DURATIONS ====================

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
  static const Duration durationVerySlow = Duration(milliseconds: 500);

  // ==================== CURVES ====================

  /// Standard easing curve for smooth animations
  static const animationCurve = Curves.easeInOut;

  /// Fast ease out for appearing elements
  static const animationCurveEaseOut = Curves.easeOut;

  /// Elastic curve for playful interactions
  static const animationCurveElastic = Curves.elasticOut;

  // ==================== ELEVATION ====================

  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // ==================== OPACITY ====================

  static const double opacityDisabled = 0.38;
  static const double opacityHover = 0.08;
  static const double opacityFocus = 0.12;
  static const double opacitySelected = 0.16;
  static const double opacityDivider = 0.12;

  // ==================== GRID LAYOUT ====================

  /// Maximum content width for responsive layouts
  static const double maxContentWidth = 1200.0;

  /// Breakpoints for responsive design
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;

  /// Grid columns
  static const int gridColumns2 = 2;
  static const int gridColumns3 = 3;
  static const int gridColumns4 = 4;

  // ==================== APP SPECIFIC ====================

  /// Heatmap grid dimensions
  static const int heatmapGridSize = 8;
  static const int heatmapTotalCells = 64;

  /// Chart heights
  static const double chartHeightSm = 120.0;
  static const double chartHeightMd = 180.0;
  static const double chartHeightLg = 240.0;

  /// Polling intervals
  static const Duration pollingInterval = Duration(seconds: 2);
  static const Duration connectionTimeout = Duration(seconds: 10);

  /// Metric tile aspect ratio
  static const double metricTileAspectRatio = 2.25;

  /// Navigation bar height
  static const double navigationBarHeight = 70.0;

  /// AppBar height
  static const double appBarHeight = 56.0;

  /// Maximum alerts to display
  static const int maxAlertsDisplay = 4;

  /// Maximum session logs to display
  static const int maxSessionLogsDisplay = 10;

  // ==================== Z-INDEX ====================

  static const int zIndexBase = 0;
  static const int zIndexDropdown = 1000;
  static const int zIndexSticky = 1020;
  static const int zIndexFixed = 1030;
  static const int zIndexModalBackdrop = 1040;
  static const int zIndexModal = 1050;
  static const int zIndexPopover = 1060;
  static const int zIndexTooltip = 1070;
}
