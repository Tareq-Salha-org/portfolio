import 'dart:async';

import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../core/widgets/widgets.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onProjectsTap;
  final VoidCallback onContactTap;

  const HeroSection({
    super.key,
    required this.onProjectsTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final scope = AppScope.of(context);
    final isMobile = Responsive.isMobile(context);

    final terminal = TerminalPanel(locale: scope.locale);

    return ContentSection(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.sectionHPadding(context),
        vertical: isMobile ? 48 : 64,
      ),
      child: Stack(
        children: [
          if (!isMobile)
            PositionedDirectional(
              start: -80,
              top: 40,
              child: GlowBackdrop(color: palette.primary, size: 460),
            ),
          Responsive.isDesktop(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: _buildHeroCopy(context)),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 4,
                      child: _Entrance(
                        delay: const Duration(milliseconds: 300),
                        child: terminal,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCopy(context),
                    const SizedBox(height: 40),
                    _Entrance(
                      delay: const Duration(milliseconds: 250),
                      child: terminal,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildHeroCopy(BuildContext context) {
    final palette = AppPalette.of(context);
    final scope = AppScope.of(context);
    final styles = AppTextStyles.of(context);
    final strings = scope.strings;

    return _Entrance(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEyebrow(context),
          const SizedBox(height: 24),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: strings.heroHeadline1, style: styles.display),
                TextSpan(text: '\n'),
                TextSpan(
                  text: strings.heroHeadline2,
                  style: styles.display.copyWith(color: palette.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              strings.heroIntro,
              style: styles.bodyLarge.copyWith(color: palette.textSecondary),
            ),
          ),
          const SizedBox(height: 32),
          _buildActions(context),
          const SizedBox(height: 28),
          _buildSocialRow(context),
        ],
      ),
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
          Text(
            PortfolioData.role,
            style: styles.labelMedium.copyWith(color: palette.textPrimary),
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
          onTap: () => AppLinks.open(PortfolioData.github),
        ),
      ],
    );
  }
}

/// Smooth entrance animation for the hero content.
///
/// Fades and lifts content on first build. Respects reduced-motion.
class _Entrance extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _Entrance({required this.child, this.delay = Duration.zero});

  @override
  State<_Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<_Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.duration(const Duration(milliseconds: 700)),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    if (Motion.reduceMotion) {
      _controller.value = 1;
    } else {
      _timer = Timer(Motion.duration(widget.delay), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
