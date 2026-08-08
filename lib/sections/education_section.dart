import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/device.dart';
import '../core/widgets/widgets.dart';
import '../models/models.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  List<Education> get _education => PortfolioData.education;
  List<PortfolioLanguage> get _languages => PortfolioData.languages;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;
    final isMobile = Responsive.isMobile(context);

    return ContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: strings.eyebrowEducation,
            title: strings.educationTitle,
            subtitle: '',
          ),
          const SizedBox(height: 40),
          isMobile ? _buildStacked(context) : _buildColumns(context),
        ],
      ),
    );
  }

  Widget _buildColumns(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: _buildEducationCard(context)),
        const SizedBox(width: 24),
        Expanded(flex: 5, child: _buildLanguagesCard(context)),
      ],
    );
  }

  Widget _buildStacked(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEducationCard(context),
        const SizedBox(height: 24),
        _buildLanguagesCard(context),
      ],
    );
  }

  Widget _buildEducationCard(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    final education = _education;
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
                  edu.localizedDegree(scope.locale),
                  style: styles.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  edu.localizedInstitution(scope.locale),
                  style: styles.bodyMedium.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: palette.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      edu.location,
                      style: styles.bodySmall.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.date_range_outlined,
                      size: 15,
                      color: palette.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      edu.period,
                      style: styles.bodySmall.copyWith(
                        color: palette.textMuted,
                      ),
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

  Widget _buildLanguagesCard(BuildContext context) {
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
              for (final language in _languages)
                _LanguageTile(name: language.localized(scope.locale)),
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
