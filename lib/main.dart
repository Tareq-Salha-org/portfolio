import 'package:flutter/material.dart';

import 'core/localization/app_locale.dart';
import 'core/localization/app_scope.dart';
import 'core/theme/theme.dart';
import 'portfolio_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SalhaPortfolio());
}

class SalhaPortfolio extends StatefulWidget {
  const SalhaPortfolio({super.key});

  @override
  State<SalhaPortfolio> createState() => _SalhaPortfolioState();
}

class _SalhaPortfolioState extends State<SalhaPortfolio> {
  bool _isDark = true;
  AppLocale _locale = AppLocale.en;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  void _toggleLocale() => setState(() {
    _locale = _locale == AppLocale.en ? AppLocale.ar : AppLocale.en;
  });

  @override
  Widget build(BuildContext context) {
    return AppScope(
      locale: _locale,
      isDark: _isDark,
      toggleTheme: _toggleTheme,
      toggleLocale: _toggleLocale,
      child: MaterialApp(
        title: 'Tareq Salha | Backend Developer Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(Brightness.light),
        darkTheme: AppTheme.build(Brightness.dark),
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        themeAnimationDuration: AppDurations.normal,
        themeAnimationCurve: Curves.easeOut,
        // Provides RTL layout for the whole tree (including dialogs) when
        // the Arabic locale is active.
        builder: (context, child) =>
            Directionality(textDirection: _locale.direction, child: child!),
        home: const PortfolioPage(),
      ),
    );
  }
}
