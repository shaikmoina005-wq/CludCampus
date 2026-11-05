import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.navyDeep,
    onPrimary: Color(0xFFF2F4F7),
    primaryContainer: Color(0xFFD6E6F7),
    onPrimaryContainer: AppColors.navyDeep,
    secondary: AppColors.navy,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.elevated,
    onSecondaryContainer: AppColors.navy,
    tertiary: AppColors.brandBlueSoft,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFE3EEF8),
    onTertiaryContainer: AppColors.navyDeep,
    error: AppColors.danger,
    onError: Colors.white,
    errorContainer: Color(0xFFFEE4E2),
    onErrorContainer: Color(0xFF7A271A),
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textMuted,
    outline: AppColors.border,
    outlineVariant: Color(0x1F0D1B30),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: AppColors.navyDeep,
    onInverseSurface: AppColors.darkTextPrimary,
    inversePrimary: AppColors.brandBlueLight,
    surfaceTint: AppColors.brandBlue,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkAccent,
    onPrimary: AppColors.darkBackground,
    primaryContainer: AppColors.navy,
    onPrimaryContainer: Color(0xFFD6E6F7),
    secondary: AppColors.brandBlueSoft,
    onSecondary: AppColors.navyDeep,
    secondaryContainer: AppColors.darkElevated,
    onSecondaryContainer: AppColors.darkTextPrimary,
    tertiary: AppColors.brandBlue,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF1C3A5C),
    onTertiaryContainer: Color(0xFFD6E6F7),
    error: AppColors.danger,
    onError: Colors.white,
    errorContainer: Color(0xFF7A271A),
    onErrorContainer: Color(0xFFFEE4E2),
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    onSurfaceVariant: AppColors.darkTextMuted,
    outline: AppColors.darkBorder,
    outlineVariant: AppColors.darkElevated,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: AppColors.elevated,
    onInverseSurface: AppColors.textPrimary,
    inversePrimary: AppColors.navy,
    surfaceTint: AppColors.brandBlueLight,
  );

  static ThemeData light() {
    const scheme = _lightScheme;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
    );
    return _applyChrome(base, scheme, dark: false);
  }

  static ThemeData dark() {
    const scheme = _darkScheme;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
    return _applyChrome(base, scheme, dark: true);
  }

  static ThemeData _applyChrome(
    ThemeData base,
    ColorScheme scheme, {
    required bool dark,
  }) {
    final on = scheme.onSurface;
    final muted = scheme.onSurfaceVariant;
    final faint = dark ? AppColors.darkTextFaint : AppColors.textFaint;

    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: on,
      displayColor: on,
    );

    return base.copyWith(
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 28,
          letterSpacing: -0.4,
          color: on,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          letterSpacing: -0.3,
          color: on,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          letterSpacing: -0.2,
          color: on,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: on,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: on,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: muted,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: faint,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: on,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? AppColors.darkBackground : AppColors.background,
        foregroundColor: on,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: on,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: on),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: dark ? scheme.primary : AppColors.primaryButton,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: on,
          side: BorderSide(color: scheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return dark ? AppColors.darkElevated : AppColors.elevated;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.darkElevated : scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: GoogleFonts.inter(
          color: faint,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(
          color: faint,
          fontSize: 15,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dark ? AppColors.darkNavBar : scheme.surface,
        elevation: 0,
        height: 72,
        indicatorColor: dark ? AppColors.darkElevated : scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? (dark ? AppColors.darkTextPrimary : AppColors.navy)
                : faint,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected
                ? (dark ? AppColors.darkTextPrimary : AppColors.navy)
                : faint,
          );
        }),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: on,
        textColor: on,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,
      ),
      dividerColor: scheme.outlineVariant,
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.primaryContainer,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: scheme.onPrimaryContainer,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
