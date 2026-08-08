import 'package:flutter/material.dart';

/// Central, semantic color palette.
///
/// Both [dark] and [light] variants are designed intentionally rather than
/// inverted. Widgets should always resolve colors through [AppPalette.of]
/// instead of hardcoding values.
///
/// Visual identity: the signature [Laravel brand red](https://laravel.com)
/// `#FF2D20`. Backgrounds are deep warm red-black (dark) or soft off-white with
/// a warm cast (light); the primary accent is Laravel red with soft coral
/// highlights. Technology colours are kept out of the palette on purpose so
/// the identity stays calm and premium.
@immutable
class AppPalette {
  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceElevated;
  final Color border;
  final Color borderStrong;
  final Color primary;
  final Color primaryStrong;
  final Color primaryHover;
  final Color primaryPressed;
  final Color primarySoft;
  final Color primaryBorder;
  final Color primaryText;
  final Color onPrimary;
  final Color accent;
  final Color accentSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color codeBackground;
  final Color success;
  final Color warning;
  final Color error;
  final Color glow;
  final Color gridLine;
  final Color scrim;

  const AppPalette({
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.borderStrong,
    required this.primary,
    required this.primaryStrong,
    required this.primaryHover,
    required this.primaryPressed,
    required this.primarySoft,
    required this.primaryBorder,
    required this.primaryText,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.codeBackground,
    required this.success,
    required this.warning,
    required this.error,
    required this.glow,
    required this.gridLine,
    required this.scrim,
  });

  /// Laravel's brand red used as the primary accent across the portfolio.
  static const Color _laravelRed = Color(0xFFFF2D20);

  static const AppPalette dark = AppPalette(
    background: Color(0xFF120B0C),
    backgroundAlt: Color(0xFF191113),
    surface: Color(0xFF1F1517),
    surfaceElevated: Color(0xFF2A1D1F),
    border: Color(0xFF3B292B),
    borderStrong: Color(0xFF4E3639),
    primary: _laravelRed,
    primaryStrong: Color(0xFFE52214),
    primaryHover: Color(0xFFFF5446),
    primaryPressed: Color(0xFFD9261C),
    primarySoft: Color(0x24FF2D20),
    primaryBorder: Color(0x55FF2D20),
    primaryText: Color(0xFFFF4D40),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFFF8A75),
    accentSoft: Color(0x1AFF8A75),
    textPrimary: Color(0xFFF5ECEB),
    textSecondary: Color(0xFFC0B0AF),
    textMuted: Color(0xFF8F7D7C),
    codeBackground: Color(0xFF150D0E),
    success: Color(0xFF4CC38A),
    warning: Color(0xFFF5C24B),
    error: Color(0xFFFF6666),
    glow: Color(0x33FF2D20),
    gridLine: Color(0x0FFFFFFF),
    scrim: Color(0xB8000000),
  );

  static const AppPalette light = AppPalette(
    background: Color(0xFFFCF7F6),
    backgroundAlt: Color(0xFFF5ECEA),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    border: Color(0xFFE8DCDA),
    borderStrong: Color(0xFFD8C4C1),
    primary: Color(0xFFE3362C),
    primaryStrong: Color(0xFFC3271F),
    primaryHover: Color(0xFFF1483D),
    primaryPressed: Color(0xFFB3221A),
    primarySoft: Color(0x18E3362C),
    primaryBorder: Color(0x48E3362C),
    primaryText: Color(0xFFC3271F),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFE65547),
    accentSoft: Color(0x16E65547),
    textPrimary: Color(0xFF2A1C1A),
    textSecondary: Color(0xFF5F4A46),
    textMuted: Color(0xFF8A7471),
    codeBackground: Color(0xFFFAF0EE),
    success: Color(0xFF059669),
    warning: Color(0xFFB45309),
    error: Color(0xFFDC2626),
    glow: Color(0x1FE3362C),
    gridLine: Color(0x0D2A1C1A),
    scrim: Color(0x592A1C1A),
  );

  /// Resolves the active palette from the current [ThemeData].
  static AppPalette of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}
