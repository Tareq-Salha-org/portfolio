import 'package:flutter/material.dart';

import '../core/animations/animations.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/motion.dart';
import '../core/widgets/widgets.dart';
import '../models/models.dart';
import 'project_visual.dart';

/// Opens the project details dialog with a polished scale + fade transition,
/// feeling connected to the card that was tapped.
Future<void> showProjectDetails(BuildContext context, Project project) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Project details',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: Motion.duration(MotionTokens.quick),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: MotionCurves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) =>
        _ProjectDetailsDialog(project: project),
  );
}

class _ProjectDetailsDialog extends StatelessWidget {
  final Project project;

  const _ProjectDetailsDialog({required this.project});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    final strings = scope.strings;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final accent = palette.primary;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 32,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 720),
        child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(19),
                      ),
                      child: ProjectVisual(
                        techStack: project.techStack,
                        primaryLanguage: project.primaryLanguage,
                        accent: accent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TechChip(
                            label: project.projectType,
                            accent: accent,
                          ),
                          const SizedBox(height: 14),
                          Text(project.name, style: styles.headline),
                          const SizedBox(height: 14),
                          Text(
                            project.description,
                            style: styles.bodyLarge.copyWith(
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 22),
                          _buildRole(context),
                          const SizedBox(height: 22),
                          _buildContributions(context),
                          const SizedBox(height: 22),
                          _buildTechStack(context),
                          const SizedBox(height: 22),
                          _buildLanguages(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: strings.dialogClose,
                    variant: AppButtonVariant.secondary,
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRole(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          scope.strings.dialogRole,
          style: styles.labelMedium.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.backgroundAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.border),
          ),
          child: Text(
            project.role,
            style: styles.bodySmall.copyWith(color: palette.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildContributions(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    final items = project.contributions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          scope.strings.dialogContributions,
          style: styles.labelMedium.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: 10),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 17,
                  color: palette.accent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: styles.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTechStack(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          scope.strings.dialogTech,
          style: styles.labelMedium.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.techStack
              .map((t) => TechChip(label: t, accent: palette.primary))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLanguages(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    final breakdown = project.languagesBreakdown;
    if (breakdown.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          scope.strings.dialogLanguages,
          style: styles.labelMedium.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: 10),
        for (final entry in breakdown.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    entry.key,
                    style: styles.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: entry.value / 100,
                      minHeight: 8,
                      backgroundColor: palette.backgroundAlt,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        palette.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 44,
                  child: Text(
                    '${entry.value.toStringAsFixed(0)}%',
                    textAlign: TextAlign.end,
                    style: styles.caption.copyWith(color: palette.textMuted),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
