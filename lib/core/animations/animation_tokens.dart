import 'package:flutter/material.dart';

/// Central motion duration tokens.
///
/// Every animation in the portfolio should source its duration from here so
/// timing stays consistent and can be tuned in one place. Wrap with
/// `Motion.duration(...)` where reduced-motion should shorten the effect.
class MotionTokens {
  MotionTokens._();

  /// Icon / underline / micro interactions.
  static const Duration micro = Duration(milliseconds: 160);

  /// Buttons, chips, small cards, nav indicators.
  static const Duration quick = Duration(milliseconds: 240);

  /// Standard state transitions (hover, drawer, dialog).
  static const Duration standard = Duration(milliseconds: 340);

  /// Section / card reveals.
  static const Duration reveal = Duration(milliseconds: 620);

  /// Complex entrance sequences (hero).
  static const Duration entrance = Duration(milliseconds: 900);

  /// Continuous background motion (particles, network, floats).
  static const Duration ambient = Duration(milliseconds: 12000);

  /// Default stagger interval between consecutive items.
  static const Duration staggerGap = Duration(milliseconds: 90);
}

/// Central easing curves for the portfolio.
///
/// UI transitions should use these instead of raw `Curves.*` so the motion
/// language stays cohesive. Continuous ambient motion may still use a linear
/// curve intentionally.
class MotionCurves {
  MotionCurves._();

  /// Default for most entrances and state changes.
  static const Cubic easeOutCubic = Curves.easeOutCubic;

  /// Smooth settle used by cards and panels.
  static const Cubic fastOutSlowIn = Curves.fastOutSlowIn;

  /// Gentle professional curve — fast start, long soft settle.
  static const Cubic gentle = Cubic(0.22, 1, 0.36, 1);

  /// Long page / section travel (navigation, timeline).
  static const Cubic easeInOutCubic = Curves.easeInOutCubic;
}
