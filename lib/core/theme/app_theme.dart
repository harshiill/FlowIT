import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// FlowIt App Theme
/// Modern white and blue color scheme for IoT dashboard
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== COLOR PALETTE ====================

  /// Primary brand colors matching logo
  static const Color primaryBlue = Color(0xFF1E5BFF);
  static const Color primaryBlueDark = Color(0xFF0D3FD9);
  static const Color primaryBlueLight = Color(0xFF4F7FFF);

  /// Accent blues
  static const Color accentBlue = Color(0xFF56B8F4);
  static const Color accentBlueLight = Color(0xFF8DD0FF);
  static const Color accentBluePale = Color(0xFFE8F5FF);

  /// Background colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF8FAFB);
  static const Color backgroundGreyLight = Color(0xFFFCFDFE);

  /// Surface colors
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF5F7F9);
  static const Color surfaceBlue = Color(0xFFF0F7FF);

  /// Text colors
  static const Color textPrimary = Color(0xFF0F1419);
  static const Color textSecondary = Color(0xFF536471);
  static const Color textTertiary = Color(0xFF8899A6);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Border colors
  static const Color borderLight = Color(0xFFE7EBF0);
  static const Color borderMedium = Color(0xFFCDD7E1);
  static const Color borderDark = Color(0xFFAAB8C2);

  /// Status colors
  static const Color success = Color(0xFF2A9D8F);
  static const Color successLight = Color(0xFFE6F7F5);
  static const Color warning = Color(0xFFF4A261);
  static const Color warningLight = Color(0xFFFFF4E6);
  static const Color error = Color(0xFFE76F51);
  static const Color errorLight = Color(0xFFFEF0EE);
  static const Color info = Color(0xFF4D96FF);
  static const Color infoLight = Color(0xFFEEF5FF);

  // ==================== SPACING SYSTEM ====================

  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // ==================== BORDER RADIUS ====================

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusRound = 999.0;

  // ==================== ELEVATION & SHADOWS ====================

  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  // ==================== LIGHT THEME ====================

  static ThemeData light() {
    final baseTextTheme = GoogleFonts.interTextTheme();

    final textTheme = baseTextTheme.copyWith(
      // Display styles (largest)
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: textPrimary,
        height: 1.12,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: textPrimary,
        height: 1.16,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textPrimary,
        height: 1.22,
      ),

      // Headline styles
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textPrimary,
        height: 1.25,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textPrimary,
        height: 1.29,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textPrimary,
        height: 1.33,
      ),

      // Title styles
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textPrimary,
        height: 1.27,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: textPrimary,
        height: 1.5,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textPrimary,
        height: 1.43,
      ),

      // Body styles
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: textPrimary,
        height: 1.5,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textSecondary,
        height: 1.43,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: textTertiary,
        height: 1.33,
      ),

      // Label styles
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textPrimary,
        height: 1.43,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textSecondary,
        height: 1.33,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textTertiary,
        height: 1.45,
      ),
    );

    final colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: textOnPrimary,
      primaryContainer: accentBluePale,
      onPrimaryContainer: textPrimary,
      secondary: accentBlue,
      onSecondary: textOnPrimary,
      secondaryContainer: surfaceBlue,
      onSecondaryContainer: textPrimary,
      tertiary: primaryBlueLight,
      onTertiary: textOnPrimary,
      error: error,
      onError: textOnPrimary,
      errorContainer: errorLight,
      onErrorContainer: error,
      surface: surfaceWhite,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceGrey,
      outline: borderMedium,
      outlineVariant: borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: backgroundWhite,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
          side: BorderSide(color: borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textOnPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Filled Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textOnPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: BorderSide(color: borderMedium, width: 1.5),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGrey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: error, width: 2),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textTertiary),
        errorStyle: textTheme.bodySmall?.copyWith(color: error),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceGrey,
        selectedColor: accentBluePale,
        disabledColor: surfaceGrey.withOpacity(0.5),
        labelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          side: BorderSide(color: borderLight, width: 1),
        ),
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.06),
        indicatorColor: accentBluePale,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: primaryBlue,
            );
          }
          return textTheme.labelMedium?.copyWith(color: textTertiary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryBlue, size: 24);
          }
          return IconThemeData(color: textTertiary, size: 24);
        }),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: textOnPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        actionTextColor: accentBlueLight,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: spacing16,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: accentBluePale,
        circularTrackColor: accentBluePale,
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryBlue,
        inactiveTrackColor: accentBluePale,
        thumbColor: primaryBlue,
        overlayColor: primaryBlue.withOpacity(0.12),
        valueIndicatorColor: primaryBlue,
        valueIndicatorTextStyle: textTheme.labelSmall?.copyWith(
          color: textOnPrimary,
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue;
          }
          return surfaceGrey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue.withOpacity(0.5);
          }
          return borderMedium;
        }),
      ),
    );
  }

  // ==================== DARK THEME ====================

  static ThemeData dark() {
    // Dark theme colors
    const darkBackground = Color(0xFF0A0E14);
    const darkSurface = Color(0xFF151B24);
    const darkSurfaceVariant = Color(0xFF1F2733);
    const darkBorder = Color(0xFF2A3441);
    const darkTextPrimary = Color(0xFFE8EAED);

    final baseTextTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    );

    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: primaryBlueLight,
      onPrimary: darkTextPrimary,
      primaryContainer: Color(0xFF1E3A5F),
      onPrimaryContainer: darkTextPrimary,
      secondary: accentBlue,
      onSecondary: darkTextPrimary,
      surface: darkSurface,
      onSurface: darkTextPrimary,
      surfaceContainerHighest: darkSurfaceVariant,
      outline: darkBorder,
      error: error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: baseTextTheme.apply(
        bodyColor: darkTextPrimary,
        displayColor: darkTextPrimary,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardTheme: CardThemeData(
        color: darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
          side: BorderSide(color: darkBorder, width: 1),
        ),
      ),
    );
  }
}
