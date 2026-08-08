import 'package:flutter/material.dart';
import 'app_locale.dart';

/// Inherited scope exposing the active locale and toggles to all sections
/// without threading callbacks through the widget tree.
class AppScope extends InheritedWidget {
  final AppLocale locale;
  final bool isDark;
  final void Function() toggleLocale;
  final void Function() toggleTheme;

  const AppScope({
    super.key,
    required this.locale,
    required this.isDark,
    required this.toggleLocale,
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

  AppStrings get strings => AppStrings.of(locale);

  bool get ar => locale == AppLocale.ar;

  TextDirection get direction => locale.direction;

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return locale != oldWidget.locale ||
        isDark != oldWidget.isDark ||
        toggleLocale != oldWidget.toggleLocale ||
        toggleTheme != oldWidget.toggleTheme;
  }
}
