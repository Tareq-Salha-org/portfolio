import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/widgets/widgets.dart';
import '../models/models.dart';
import 'project_details_dialog.dart';
import 'project_visual.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  List<Project> get _projects => PortfolioData.projects;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;
    final projects = _projects;

    return ContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: strings.eyebrowProjects,
            title: strings.projectsTitle,
            subtitle: strings.projectsSubtitle,
          ),
          const SizedBox(height: 48),
          if (projects.isNotEmpty)
            AnimatedReveal(
              offset: 26,
              child: _FeaturedProjectCard(project: projects.first),
            ),
          const SizedBox(height: 32),
          if (projects.length > 1)
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900 ? 2 : 1;
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    mainAxisExtent: 430,
                  ),
                  itemCount: projects.length - 1,
                  itemBuilder: (context, index) =>
                      _ProjectCard(project: projects[index + 1]),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  final Project project;

  const _FeaturedProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    final strings = scope.strings;

    return HoverCard(
      onTap: () => showProjectDetails(context, project),
      radius: BorderRadius.circular(AppRadius.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectVisual(
            techStack: project.techStack,
            primaryLanguage: project.primaryLanguage,
            accent: palette.primary,
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TechChip(
                        label: project.localizedType(scope.locale),
                        accent: palette.primary,
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 19,
                      color: palette.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  project.name,
                  style: styles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  project.localizedDescription(scope.locale),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: styles.bodyMedium.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTags(context),
                const SizedBox(height: 20),
                Text(
                  '${strings.cardRole}:  ${project.localizedRole(scope.locale).split('\n').first}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: styles.bodySmall.copyWith(color: palette.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final palette = AppPalette.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: project.techStack
          .take(4)
          .map((t) => TechChip(label: t, accent: palette.primary))
          .toList(),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    final strings = scope.strings;

    return HoverCard(
      onTap: () => showProjectDetails(context, project),
      radius: BorderRadius.circular(AppRadius.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectVisual(
            techStack: project.techStack,
            primaryLanguage: project.primaryLanguage,
            accent: palette.primary,
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TechChip(
                  label: project.localizedType(scope.locale),
                  accent: palette.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  project.name,
                  style: styles.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  project.localizedDescription(scope.locale),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: styles.bodySmall.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                _buildTags(context),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${strings.cardRole}: ${project.roleEn.split(' - ').first}',
                        style: styles.caption.copyWith(
                          color: palette.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: palette.primary,
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

  Widget _buildTags(BuildContext context) {
    final palette = AppPalette.of(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: project.techStack
          .take(4)
          .map((t) => TechChip(label: t, accent: palette.primary))
          .toList(),
    );
  }
}
