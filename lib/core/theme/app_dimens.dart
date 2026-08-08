/// Consistent spacing and radius tokens used across the whole portfolio.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
  static const double huge = 96;
}

class AppRadius {
  AppRadius._();

  static const double tiny = 6;
  static const double chip = 8;
  static const double button = 12;
  static const double card = 16;
  static const double panel = 20;
  static const double pill = 999;
}

class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 600);
}
