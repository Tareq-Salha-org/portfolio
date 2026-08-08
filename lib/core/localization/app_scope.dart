import 'package:flutter/material.dart';
import 'app_locale.dart';

/// Inherited scope exposing theme state and toggles to all sections without
/// threading callbacks through the widget tree.
///
/// The app is English-only, so no locale state lives here — portfolio content
/// can never be tied to a language switch.
class AppScope extends InheritedWidget {
  final bool isDark;
  final void Function() toggleTheme;

  const AppScope({
    super.key,
    required this.isDark,
    required this.toggleTheme,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!;
  }

  /// Access the scope without registering a dependency (used in callbacks).
  static AppScope read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<AppScope>();
    return element?.widget as AppScope;
  }

  AppStrings get strings => AppStrings.of;

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return isDark != oldWidget.isDark || toggleTheme != oldWidget.toggleTheme;
  }
}
