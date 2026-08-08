import 'package:flutter/material.dart';

import 'core/data/portfolio_data.dart';
import 'core/localization/app_scope.dart';
import 'core/theme/theme.dart';
import 'portfolio_gate.dart';

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

  @override
  void initState() {
    super.initState();
    // The portfolio JSON bootstrap starts here — at the application root,
    // before any page or section is built. It is fully independent of locale,
    // theme, animations and user interaction, and runs exactly once.
    PortfolioData.load();
  }

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return AppScope(
      isDark: _isDark,
      toggleTheme: _toggleTheme,
      child: MaterialApp(
        title: 'Tareq Salha | Backend Developer Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(Brightness.light),
        darkTheme: AppTheme.build(Brightness.dark),
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        themeAnimationDuration: AppDurations.normal,
        themeAnimationCurve: Curves.easeOut,
        // The gate owns the loading → error → loaded lifecycle, so the first
        // meaningful frame is never an empty portfolio.
        home: const PortfolioGate(),
      ),
    );
  }
}
