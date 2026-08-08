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
      child: StaggeredGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StaggeredItem(
              index: 0,
              child: SectionHeader(
                eyebrow: strings.eyebrowSkills,
                title: strings.skillsTitle,
                subtitle: strings.skillsSubtitle,
              ),
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
                final cardWidth =
                    (width - (columns - 1) * 20) / columns;
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    for (var i = 0; i < _categories.length; i++)
                      SizedBox(
                        width: cardWidth,
                        child: StaggeredItem(
                          index: i + 1,
                          offset: 24,
                          child: _SkillCategoryCard(
                            category: _categories[i],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCategoryCard extends StatelessWidget {
  final SkillCategory category;

  const _SkillCategoryCard({required this.category});

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

    final chips = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: category.skills
          .map((skill) => TechChip(label: skill, accent: palette.accent))
          .toList(),
    );

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
                  category.title,
                  style: styles.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          chips,
        ],
      ),
    );
  }
}
