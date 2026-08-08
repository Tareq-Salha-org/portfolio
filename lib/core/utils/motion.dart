import 'package:flutter/material.dart';

/// Accessibility helper that respects the user's "reduce motion" preference
/// when exposed by the platform / Flutter framework.
class Motion {
  Motion._();

  /// Returns true when the user has requested reduced motion.
  static bool get reduceMotion => WidgetsBinding
      .instance
      .platformDispatcher
      .accessibilityFeatures
      .reduceMotion;

  /// When reduced motion is requested, most decorative animations should
  /// either be skipped or shortened to a near-zero duration.
  static Duration duration(Duration preferred) =>
      reduceMotion ? Duration.zero : preferred;
}
