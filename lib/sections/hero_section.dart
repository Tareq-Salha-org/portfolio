import 'package:flutter/material.dart';

import '../core/animations/animations.dart';
import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../core/widgets/widgets.dart';

class HeroSection extends StatelessWidget {
  final ScrollController? scrollController;
  final VoidCallback onProjectsTap;
  final VoidCallback onContactTap;

  const HeroSection({
    super.key,
    this.scrollController,
    required this.onProjectsTap,
    required this.onContactTap,
  });

  /// Responsive hero headline size — deliberately larger on desktop, compact
  /// on phones so it never dominates the viewport.
  double _headlineSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 380) return 34;
    if (width < 480) return 38;
    if (width < 600) return 42;
    if (width < 900) return 48;
    if (width < 1280) return 54;
    if (width < 1600) return 60;
    return 66;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    final terminal = _buildVisual(context);

    // One staggered sequence for the whole hero: badge → headline → intro →
    // actions → social row → technical visual. The same indices work for the
    // side-by-side desktop layout and the stacked mobile layout.
    Widget content = ContentSection(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.sectionHPadding(context),
        vertical: isMobile ? 44 : 64,
      ),
      child: StaggeredGroup(
        duration: MotionTokens.entrance,
        intervalFraction: 0.11,
        itemFraction: 0.4,
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: _buildHeroCopy(context)),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 4,
                    child: StaggeredItem(index: 6, offset: 30, child: terminal),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroCopy(context),
                  const SizedBox(height: 40),
                  StaggeredItem(index: 6, offset: 30, child: terminal),
                  if (!isMobile) ...[
                    const SizedBox(height: 28),
                    const StaggeredItem(
                      index: 7,
                      offset: 16,
                      child: _ScrollHint(),
                    ),
                  ],
                ],
              ),
      ),
    );

    // The hero fades and drifts upward as the user scrolls away, while the
    // page background (parallax layer) moves slower behind it.
    if (scrollController != null) {
      content = ParallaxElement(
        controller: scrollController!,
        factor: 0.22,
        range: 480,
        child: content,
      );
    }
    return content;
  }

  Widget _buildVisual(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDesktop = Responsive.isDesktop(context);

    final terminal = const TerminalPanel();

    return Stack(
      children: [
        if (isDesktop) ...[
          // Subtle floating technical ornaments behind the terminal.
          Positioned(
            top: -18,
            right: -10,
            child: FloatingElement(
              amplitude: 7,
              phase: 1.2,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: palette.primary.withValues(alpha: 0.22),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -14,
            left: -18,
            child: FloatingElement(
              amplitude: 10,
              phase: 3.4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.primary.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ],
        terminal,
      ],
    );
  }

  Widget _buildHeroCopy(BuildContext context) {
    final palette = AppPalette.of(context);
    final scope = AppScope.of(context);
    final styles = AppTextStyles.of(context);
    final strings = scope.strings;
    final headlineSize = _headlineSize(context);

    final headline = styles.display.copyWith(
      fontSize: headlineSize,
      height: 1.12,
      letterSpacing: -1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredItem(index: 0, offset: 20, child: _buildEyebrow(context)),
        const SizedBox(height: 22),
        StaggeredItem(
          index: 1,
          offset: 28,
          child: Text(
            PortfolioData.fullName,
            style: headline,
          ),
        ),
        const SizedBox(height: 14),
        StaggeredItem(
          index: 2,
          offset: 26,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: strings.heroHeadline1, style: headline),
                TextSpan(text: '\n'),
                TextSpan(
                  text: strings.heroHeadline2,
                  style: headline.copyWith(color: palette.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        StaggeredItem(
          index: 3,
          offset: 28,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              strings.heroIntro,
              style: styles.bodyLarge.copyWith(color: palette.textSecondary),
            ),
          ),
        ),
        const SizedBox(height: 28),
        StaggeredItem(index: 4, offset: 26, child: _buildActions(context)),
        const SizedBox(height: 24),
        StaggeredItem(index: 5, offset: 22, child: _buildSocialRow(context)),
      ],
    );
  }

  Widget _buildEyebrow(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: palette.success,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: palette.success.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              PortfolioData.role,
              style: styles.labelMedium.copyWith(color: palette.textPrimary),
            ),
          ),
          Container(
            width: 1,
            height: 14,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: palette.border,
          ),
          Text(
            PortfolioData.location,
            style: styles.labelMedium.copyWith(color: palette.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final scope = AppScope.of(context);
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        AppButton(
          label: scope.strings.heroCtaProjects,
          icon: Icons.arrow_forward_rounded,
          onTap: onProjectsTap,
        ),
        AppButton(
          label: scope.strings.heroCtaContact,
          icon: Icons.mail_outline_rounded,
          variant: AppButtonVariant.secondary,
          onTap: onContactTap,
        ),
      ],
    );
  }

  Widget _buildSocialRow(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Find me:',
          style: styles.caption.copyWith(color: palette.textMuted),
        ),
        const SizedBox(width: 14),
        AppIconButton(
          icon: Icons.mail_outline,
          tooltip: 'Email',
          onTap: () => AppLinks.open(AppLinks.mailto(PortfolioData.email)),
        ),
        const SizedBox(width: 10),
        AppIconButton(
          icon: Icons.link,
          tooltip: 'LinkedIn',
          onTap: () => AppLinks.open(PortfolioData.linkedIn),
        ),
        const SizedBox(width: 10),
        AppIconButton(
          icon: Icons.code,
          tooltip: 'GitHub',
          svg: 'github',
          onTap: () => AppLinks.open(PortfolioData.github),
        ),
      ],
    );
  }
}

/// Gentle bouncing scroll hint shown below the hero on larger screens.
class _ScrollHint extends StatelessWidget {
  const _ScrollHint();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return IgnorePointer(
      child: FloatingElement(
        amplitude: 5,
        duration: const Duration(milliseconds: 2600),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppScope.of(context).strings.heroScroll,
              style: styles.caption.copyWith(color: palette.textMuted),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: palette.primary,
            ),
          ],
        ),
      ),
    );
  }
}
