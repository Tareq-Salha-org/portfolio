import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/widgets/widgets.dart';
import '../models/models.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  List<SkillCategory> get _categories => PortfolioData.skillCategories;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;

    return ContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: strings.eyebrowSkills,
            title: strings.skillsTitle,
            subtitle: strings.skillsSubtitle,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 1100
                  ? 4
                  : width >= 680
                  ? 2
                  : 1;
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 196,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) => _SkillCategoryCard(
                  category: _categories[index],
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillCategoryCard extends StatelessWidget {
  final SkillCategory category;
  final int index;

  const _SkillCategoryCard({required this.category, required this.index});

  IconData _icon() {
    switch (category.iconKey) {
      case 'backend':
        return Icons.code_rounded;
      case 'integrations':
        return Icons.hub_outlined;
      case 'devops':
        return Icons.rocket_launch_outlined;
      case 'core':
        return Icons.tune_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);

    return HoverCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon(), size: 20, color: palette.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.localizedTitle(scope.locale),
                  style: styles.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: category
                  .localizedSkills(scope.locale)
                  .map(
                    (skill) => TechChip(label: skill, accent: palette.accent),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
