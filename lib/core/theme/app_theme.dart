import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Builds the [ThemeData] used by the app for a given [Brightness].
class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'Inter';

  static TextStyle _ts(
    AppPalette p,
    double px,
    FontWeight weight, {
    Color? color,
    double height = 1.4,
  }) => TextStyle(
    fontFamily: _fontFamily,
    fontSize: px,
    fontWeight: weight,
    color: color ?? p.textPrimary,
    height: height,
  );

  static ThemeData build(Brightness brightness) {
    final palette = brightness == Brightness.dark
        ? AppPalette.dark
        : AppPalette.light;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: palette.primary,
          brightness: brightness,
        ).copyWith(
          primary: palette.primary,
          secondary: palette.accent,
          surface: palette.surface,
          onSurface: palette.textPrimary,
          error: palette.error,
          outline: palette.border,
        );

    final baseText = TextTheme(
      displayLarge: _ts(palette, 48, FontWeight.w800, height: 1.12),
      displayMedium: _ts(palette, 38, FontWeight.w800, height: 1.15),
      headlineLarge: _ts(palette, 30, FontWeight.w700, height: 1.25),
      headlineMedium: _ts(palette, 24, FontWeight.w700, height: 1.25),
      titleLarge: _ts(palette, 21, FontWeight.w700, height: 1.3),
      titleMedium: _ts(palette, 18, FontWeight.w600, height: 1.35),
      bodyLarge: _ts(palette, 17, FontWeight.w400, height: 1.7),
      bodyMedium: _ts(palette, 15.5, FontWeight.w400, height: 1.65),
      bodySmall: _ts(palette, 14, FontWeight.w400, height: 1.6),
      labelLarge: _ts(palette, 16, FontWeight.w600, height: 1.3),
      labelMedium: _ts(palette, 13.5, FontWeight.w600, height: 1.3),
      labelSmall: _ts(palette, 12, FontWeight.w500, height: 1.4),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      fontFamily: _fontFamily,
      dividerColor: palette.border,
      splashFactory: InkRipple.splashFactory,
      textTheme: baseText,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: palette.primary,
        selectionColor: palette.primary.withAlpha(45),
        selectionHandleColor: palette.primary,
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: palette.surfaceElevated,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: palette.border),
        ),
        textStyle: _ts(
          palette,
          12,
          FontWeight.w500,
          color: palette.textPrimary,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: palette.border),
        ),
        titleTextStyle: _ts(palette, 22, FontWeight.w700),
        contentTextStyle: _ts(
          palette,
          15.5,
          FontWeight.w400,
          color: palette.textSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.backgroundAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: _inputBorder(palette.border),
        enabledBorder: _inputBorder(palette.border),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.error, width: 1.5),
        ),
        hintStyle: TextStyle(color: palette.textMuted, fontFamily: _fontFamily),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );
}
