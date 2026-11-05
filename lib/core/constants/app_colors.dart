import 'package:flutter/material.dart';

/// Live demo tokens from cludcampus.com CSS ([data-theme=light|dark]).
/// Logo brand blues kept for wordmark / mark accents only.
class AppColors {
  /// Soft page background — demo `--bg`.
  static const Color background = Color(0xFFEEF1F6);

  /// Primary navy text / chrome — demo `--fg`.
  static const Color navy = Color(0xFF0D1B30);

  /// Deepest navy — primary buttons / accent bars — demo `--accent`.
  static const Color navyDeep = Color(0xFF12233D);

  /// Primary button / accent bars.
  static const Color primaryButton = navyDeep;

  /// Brand blue — logo letter face / wordmark "Campus".
  static const Color brandBlue = Color(0xFF1A8AD4);

  static const Color brandBlueLight = Color(0xFF3A96DA);
  static const Color brandBlueSoft = Color(0xFF4A90C8);

  /// Attendance / success — demo `--success`.
  static const Color attendanceGreen = Color(0xFF409370);

  static const Color surface = Color(0xFFFEFEFF);

  /// Elevated / subtle fill — demo `--bg-subtle`.
  static const Color elevated = Color(0xFFE4E9F1);
  static const Color surfaceMuted = elevated;

  static const Color textPrimary = Color(0xFF0D1B30);
  static const Color textMuted = Color(0xFF5B6B82);
  static const Color textFaint = Color(0xFF7C8AA0);

  static const Color border = Color(0xFFD0D5DD);
  static const Color borderLight = Color(0xFFE4E9F1);

  static const Color success = attendanceGreen;
  static const Color warning = Color(0xFF9A7B3A);
  static const Color danger = Color(0xFFC24B4B);

  /// Legacy aliases used across screens.
  static const Color accent = brandBlue;
  static const Color accentLight = brandBlueLight;
  static const Color textSecondary = textMuted;

  /// Soft highlight for live college card.
  static const Color liveHighlight = Color(0xFFD6E6F7);

  // --- Dark mode — demo `--bg` / `--bg-elevated` / `--fg` ---
  static const Color darkBackground = Color(0xFF091525);
  static const Color darkSurface = Color(0xFF12233D);
  static const Color darkElevated = Color(0xFF1A2D4D);
  static const Color darkBorder = Color(0xFF2A3B52);
  static const Color darkTextPrimary = Color(0xFFF2F4F7);
  static const Color darkTextMuted = Color(0xFF9AA8BD);
  static const Color darkTextFaint = Color(0xFF6E7D94);
  static const Color darkNavBar = Color(0xFF0B1524);
  static const Color darkAccent = Color(0xFFE8EEF6);

  /// Calendar legend / day markers.
  static const Color holidayGreen = Color(0xFF2F8A62);
  static const Color reminderAmber = Color(0xFF9A7B3A);

  /// Soft status fills.
  static Color successSoft([double a = 0.16]) => success.withValues(alpha: a);
  static Color warningSoft([double a = 0.16]) => warning.withValues(alpha: a);
  static Color dangerSoft([double a = 0.16]) => danger.withValues(alpha: a);

  /// Varied option/tile tints (cycle for inner menus) — muted for demo look.
  static const List<Color> optionTints = [
    textMuted,
    navy,
    brandBlueSoft,
    Color(0xFF3D6B99),
    Color(0xFF1E5A8C),
    Color(0xFF5B8FBF),
  ];

  // --- Theme-aware helpers (preserved API) ---

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color scaffoldOf(BuildContext context) =>
      isDark(context) ? darkBackground : background;

  static Color cardOf(BuildContext context) =>
      isDark(context) ? darkSurface : surface;

  static Color elevatedOf(BuildContext context) =>
      isDark(context) ? darkElevated : elevated;

  static Color borderOf(BuildContext context) =>
      isDark(context) ? darkBorder : Color(0x1F0D1B30); // ~12% fg

  static Color primaryTextOf(BuildContext context) =>
      isDark(context) ? darkTextPrimary : textPrimary;

  static Color mutedTextOf(BuildContext context) =>
      isDark(context) ? darkTextMuted : textMuted;

  static Color faintTextOf(BuildContext context) =>
      isDark(context) ? darkTextFaint : textFaint;

  static Color dividerOf(BuildContext context) =>
      isDark(context) ? darkBorder : Color(0x1F0D1B30);

  static Color pillBgOf(BuildContext context) =>
      isDark(context) ? darkElevated : elevated;

  static Color chromeAccentOf(BuildContext context) =>
      isDark(context) ? darkAccent : primaryButton;
}
