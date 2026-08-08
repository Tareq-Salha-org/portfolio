import 'package:flutter/material.dart';

/// Central, semantic color palette.
///
/// Both [dark] and [light] variants are designed intentionally rather than
/// inverted. Widgets should always resolve colors through [AppPalette.of]
/// instead of hardcoding values.
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

  /// Laravel-inspired red used as the primary accent across the portfolio.
  static const Color _laravelRed = Color(0xFFFF2D20);

  static const AppPalette dark = AppPalette(
    background: Color(0xFF0B1220),
    backgroundAlt: Color(0xFF0E1626),
    surface: Color(0xFF111B2E),
    surfaceElevated: Color(0xFF17233A),
    border: Color(0xFF1F2B42),
    borderStrong: Color(0xFF2B3C58),
    primary: _laravelRed,
    primaryStrong: Color(0xFFE0261A),
    primaryHover: Color(0xFFFF4D3D),
    primaryPressed: Color(0xFFD92317),
    primarySoft: Color(0x1AFF2D20),
    primaryBorder: Color(0x4DFF2D20),
    primaryText: Color(0xFFFF2D20),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFF34D399),
    accentSoft: Color(0x1734D399),
    textPrimary: Color(0xFFE9EFF6),
    textSecondary: Color(0xFFA7B6CC),
    textMuted: Color(0xFF7B8CAD),
    codeBackground: Color(0xFF0D1526),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
    glow: Color(0x33FF2D20),
    gridLine: Color(0x0FFFFFFF),
    scrim: Color(0xB8000000),
  );

  static const AppPalette light = AppPalette(
    background: Color(0xFFF6F8FB),
    backgroundAlt: Color(0xFFEEF2F7),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    border: Color(0xFFE1E8F0),
    borderStrong: Color(0xFFC9D4E0),
    primary: _laravelRed,
    primaryStrong: Color(0xFFE0261A),
    primaryHover: Color(0xFFFF4D3D),
    primaryPressed: Color(0xFFD92317),
    primarySoft: Color(0x14FF2D20),
    primaryBorder: Color(0x40FF2D20),
    primaryText: Color(0xFFE0261A),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFF059669),
    accentSoft: Color(0x14059669),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF3B4C63),
    textMuted: Color(0xFF64748B),
    codeBackground: Color(0xFFF1F5F9),
    success: Color(0xFF059669),
    warning: Color(0xFFB45309),
    error: Color(0xFFDC2626),
    glow: Color(0x1AFF2D20),
    gridLine: Color(0x0D0F172A),
    scrim: Color(0x590F172A),
  );

  /// Resolves the active palette from the current [ThemeData].
  static AppPalette of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}
