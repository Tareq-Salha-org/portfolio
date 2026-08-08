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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(PortfolioData.fullName, style: styles.titleMedium),
                      Text(
                        strings.footerTagline,
                        style: styles.caption.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AppIconButton(
                        icon: Icons.code,
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
                        onTap: () =>
                            AppLinks.open(AppLinks.mailto(PortfolioData.email)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: palette.border, height: 1),
              const SizedBox(height: 18),
              Text(
                strings.footerBuilt,
                style: styles.caption.copyWith(color: palette.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
