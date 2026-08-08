import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/data/portfolio_data.dart';
import 'core/localization/app_locale.dart';
import 'core/theme/theme.dart';
import 'core/widgets/widgets.dart';
import 'portfolio_page.dart';

/// Root startup gate that owns the initial data lifecycle.
///
/// `PortfolioData.load()` is kicked off from the app root (main.dart), so by
/// the time this widget is built the store is already at least *loading*. This
/// gate reacts to the store's reactive [PortfolioData.status]:
///
/// ```text
/// App starts
///     ↓
/// PortfolioData.load()   ← app root, independent of any widget
///     ↓
/// Loading screen         ← first frame, never an empty portfolio
///     ↓
/// Data loaded            ← one-time; reused for the whole session
///     ↓
/// PortfolioPage          ← every section reads fully-parsed data
/// ```
///
/// Failures surface as a branded error screen with a retry action instead of
/// a silently empty website.
class PortfolioGate extends StatelessWidget {
  const PortfolioGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PortfolioDataStatus>(
      valueListenable: PortfolioData.status,
      builder: (context, status, _) {
        final Widget child = switch (status) {
          PortfolioDataStatus.loading => const _LoadingScreen(),
          PortfolioDataStatus.error => const _ErrorScreen(),
          PortfolioDataStatus.loaded => const PortfolioPage(),
        };
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: KeyedSubtree(key: ValueKey(status), child: child),
        );
      },
    );
  }
}

/// Branded full-screen loading state shown while the JSON is being fetched.
/// It only appears on the very first frames; the asset is tiny.
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final strings = AppStrings.of;

    return Scaffold(
      backgroundColor: palette.background,
      body: GridBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [palette.primary, palette.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: palette.glow,
                      blurRadius: 40,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'TS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(strings.gateLoadingTitle, style: styles.titleLarge),
              const SizedBox(height: 8),
              Text(
                strings.gateLoadingSubtitle,
                textAlign: TextAlign.center,
                style: styles.bodySmall.copyWith(color: palette.textMuted),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(palette.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Branded full-screen error state with a retry action.
///
/// The visitor sees a friendly message; the technical detail is only shown in
/// debug builds and is always logged to the console by [PortfolioData.load].
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final strings = AppStrings.of;
    final detail = PortfolioData.lastError;

    return Scaffold(
      backgroundColor: palette.background,
      body: GridBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: palette.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: palette.error.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 30,
                      color: palette.error,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(strings.gateErrorTitle, style: styles.titleLarge),
                  const SizedBox(height: 10),
                  Text(
                    strings.gateErrorBody,
                    textAlign: TextAlign.center,
                    style: styles.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  if (kDebugMode && detail != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: palette.codeBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: palette.border),
                      ),
                      child: Text(
                        detail,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: styles.code.copyWith(
                          color: palette.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 26),
                  AppButton(
                    label: strings.gateRetry,
                    icon: Icons.refresh_rounded,
                    onTap: () => PortfolioData.load(force: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
