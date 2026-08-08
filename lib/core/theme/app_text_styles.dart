import 'package:flutter/material.dart';
import 'app_palette.dart';

/// Typography scale built on the bundled local `Inter` font family.
///
/// [TextStyles.of] returns the scale for the active palette with responsive
/// font sizing so typography feels consistent from phones to 4K monitors.
class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Inter';

  /// Scales font sizes subtly based on the viewport width.
  static double scaleFactor(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 560) return 0.88;
    if (width < 768) return 0.94;
    if (width >= 1600) return 1.06;
    return 1.0;
  }

  static TextStyle build(
    BuildContext context,
    double px,
    FontWeight weight, {
    Color? color,
    double height = 1.4,
    double? letterSpacing,
  }) {
    final palette = AppPalette.of(context);
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: px * scaleFactor(context),
      fontWeight: weight,
      color: color ?? palette.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyles of(BuildContext context) => TextStyles(context);
}

/// A named hierarchy of text styles for the portfolio.
class TextStyles {
  final BuildContext context;

  TextStyles(this.context);

  TextStyle _ts(
    double px,
    FontWeight weight, {
    Color? color,
    double height = 1.4,
    double? letterSpacing,
  }) => AppTextStyles.build(
    context,
    px,
    weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  TextStyle get display =>
      _ts(48, FontWeight.w800, height: 1.12, letterSpacing: -1.2);

  TextStyle get displayMedium =>
      _ts(38, FontWeight.w800, height: 1.15, letterSpacing: -0.8);

  TextStyle get headline => _ts(30, FontWeight.w700, height: 1.25);

  TextStyle get headlineMedium => _ts(24, FontWeight.w700, height: 1.25);

  TextStyle get titleLarge => _ts(21, FontWeight.w700, height: 1.3);

  TextStyle get titleMedium => _ts(18, FontWeight.w600, height: 1.35);

  TextStyle get bodyLarge => _ts(17, FontWeight.w400, height: 1.7);

  TextStyle get bodyMedium => _ts(15.5, FontWeight.w400, height: 1.65);

  TextStyle get bodySmall => _ts(14, FontWeight.w400, height: 1.6);

  TextStyle get labelLarge => _ts(16, FontWeight.w600, height: 1.3);

  TextStyle get labelMedium =>
      _ts(13.5, FontWeight.w600, height: 1.3, letterSpacing: 0.2);

  TextStyle get caption =>
      _ts(12.5, FontWeight.w500, height: 1.4, letterSpacing: 0.3);

  TextStyle get code =>
      _ts(13.5, FontWeight.w500, height: 1.7, letterSpacing: 0.2);
}
