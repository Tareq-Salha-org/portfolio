import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

/// Centralised responsive helpers. Sections should never re-implement
/// width comparisons with magic numbers.
class Responsive {
  Responsive._();

  static const double _mobileMax = 600;
  static const double _desktopMin = 1024;
  static const double _contentMax = 1280;

  static DeviceType of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < _mobileMax) return DeviceType.mobile;
    if (width < _desktopMin) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) =>
      of(context) == DeviceType.tablet;
  static bool isDesktop(BuildContext context) =>
      of(context) == DeviceType.desktop;

  /// Horizontal padding for a section inside the page.
  static double sectionHPadding(BuildContext context) {
    switch (of(context)) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 40;
      case DeviceType.desktop:
        return 56;
    }
  }

  /// Vertical padding separating major sections.
  static double sectionVPadding(BuildContext context) {
    switch (of(context)) {
      case DeviceType.mobile:
        return 56;
      case DeviceType.tablet:
        return 80;
      case DeviceType.desktop:
        return 96;
    }
  }

  /// Maximum usable content width (prevents content stretching on ultra-wide).
  static double contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= _contentMax) return _contentMax;
    return width;
  }

  /// Number of columns a grid should use on the current device.
  static int gridColumns(BuildContext context) {
    switch (of(context)) {
      case DeviceType.mobile:
        return 1;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
        return 4;
    }
  }
}
