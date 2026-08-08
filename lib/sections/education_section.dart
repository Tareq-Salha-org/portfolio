import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/device.dart';
import '../core/widgets/widgets.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;
    final isMobile = Responsive.isMobile(context);

    return ContentSection(
      child: StaggeredGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StaggeredItem(
              index: 0,
              child: SectionHeader(
                eyebrow: strings.eyebrowEducation,
                title: strings.educationTitle,
                subtitle: '',
              ),
            ),
            const SizedBox(height: 40),
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StaggeredItem(index: 1, child: _EducationCard()),
                      const SizedBox(height: 24),
                      const StaggeredItem(index: 2, child: _LanguagesCard()),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 6,
                        child: StaggeredItem(index: 1, child: _EducationCard()),
                      ),
                      const SizedBox(width: 24),
                      const Expanded(
                        flex: 5,
                        child: StaggeredItem(index: 2, child: _LanguagesCard()),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final education = PortfolioData.education;
    if (education.isEmpty) return const SizedBox.shrink();
    final edu = education.first;

    return HoverCard(
      padding: const EdgeInsets.all(26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.school_outlined,
              size: 24,
              color: palette.primary,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu.degree,
                  style: styles.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  edu.institution,
                  style: styles.bodyMedium.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _MetaItem(
                      icon: Icons.location_on_outlined,
                      label: edu.location,
                    ),
                    _MetaItem(
                      icon: Icons.date_range_outlined,
                      label: edu.period,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: palette.textMuted),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.build(
            context,
            13.5,
            FontWeight.w400,
            color: palette.textMuted,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _LanguagesCard extends StatelessWidget {
  const _LanguagesCard();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);

    return HoverCard(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.translate, size: 20, color: palette.primary),
              const SizedBox(width: 10),
              Text(scope.strings.languagesTitle, style: styles.titleMedium),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final language in PortfolioData.languages)
                _LanguageTile(name: language.name),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String name;

  const _LanguageTile({required this.name});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: palette.accentSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.accent.withValues(alpha: 0.4)),
      ),
      child: Text(
        name,
        style: AppTextStyles.build(
          context,
          14,
          FontWeight.w600,
          color: palette.accent,
          height: 1.2,
        ),
      ),
    );
  }
}
