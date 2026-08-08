import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../core/widgets/widgets.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final scope = AppScope.of(context);
    final strings = scope.strings;
    final styles = AppTextStyles.of(context);
    final isMobile = Responsive.isMobile(context);

    final brand = Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(PortfolioData.fullName, style: styles.titleMedium),
        Text(
          strings.footerTagline,
          style: styles.caption.copyWith(color: palette.textMuted),
        ),
      ],
    );

    final socials = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: Icons.code,
          svg: 'github',
          tooltip: 'GitHub',
          onTap: () => AppLinks.open(PortfolioData.github),
        ),
        const SizedBox(width: 10),
        AppIconButton(
          icon: Icons.link,
          tooltip: 'LinkedIn',
          onTap: () => AppLinks.open(PortfolioData.linkedIn),
        ),
        const SizedBox(width: 10),
        AppIconButton(
          icon: Icons.email_outlined,
          tooltip: 'Email',
          onTap: () => AppLinks.open(AppLinks.mailto(PortfolioData.email)),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              if (isMobile) ...[
                brand,
                const SizedBox(height: 22),
                socials,
              ] else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [brand, socials],
                ),
              const SizedBox(height: 26),
              // Accent hairline reveals as the footer enters the viewport.
              AnimatedReveal(
                offset: 8,
                child: Container(
                  width: 110,
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        palette.primary.withValues(alpha: 0.15),
                        palette.primary,
                        palette.primary.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                strings.footerBuilt,
                textAlign: TextAlign.center,
                style: styles.caption.copyWith(color: palette.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
