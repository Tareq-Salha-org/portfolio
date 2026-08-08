import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/device.dart';
import '../core/widgets/widgets.dart';
import '../models/models.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  List<Experience> get _experiences => PortfolioData.experience;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;

    return ContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: strings.eyebrowExperience,
            title: strings.experienceTitle,
            subtitle: strings.experienceSubtitle,
          ),
          const SizedBox(height: 48),
          _buildTimeline(context),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Column(
      children: [
        for (var i = 0; i < _experiences.length; i++)
          AnimatedReveal(
            duration: AppDurations.slow,
            offset: 28,
            child: _TimelineItem(
              experience: _experiences[i],
              index: i,
              isLast: i == _experiences.length - 1,
              isMobile: isMobile,
            ),
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Experience experience;
  final int index;
  final bool isLast;
  final bool isMobile;

  const _TimelineItem({
    required this.experience,
    required this.index,
    required this.isLast,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: _buildCard(context),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRail(context),
          const SizedBox(width: 28),
          Expanded(child: _buildCard(context)),
        ],
      ),
    );
  }

  Widget _buildRail(BuildContext context) {
    final palette = AppPalette.of(context);
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: palette.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: palette.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: palette.background,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      palette.primary.withValues(alpha: 0.7),
                      palette.border,
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final palette = AppPalette.of(context);
    final scope = AppScope.of(context);

    return HoverCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.role,
                      style: AppTextStyles.of(context).titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.business_center_outlined,
                          size: 15,
                          color: palette.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            experience.company,
                            style: AppTextStyles.of(
                              context,
                            ).bodySmall.copyWith(color: palette.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 12,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          color: palette.border,
                        ),
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: palette.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            experience.location,
                            style: AppTextStyles.of(
                              context,
                            ).bodySmall.copyWith(color: palette.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildDateBadge(context),
            ],
          ),
          const SizedBox(height: 20),
          for (final item in experience.responsibilitiesOf(scope.locale))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: palette.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.of(
                        context,
                      ).bodySmall.copyWith(color: palette.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          if (experience.achievementsOf(scope.locale).isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildAchievements(context),
          ],
        ],
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: palette.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: palette.primary.withValues(alpha: 0.35)),
      ),
      child: Text(
        experience.dateRange,
        style: AppTextStyles.build(
          context,
          12.5,
          FontWeight.w600,
          color: palette.primary,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final strings = AppScope.of(context).strings;
    final items = experience.achievementsOf(AppScope.of(context).locale);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.accentSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 17,
                color: palette.accent,
              ),
              const SizedBox(width: 8),
              Text(
                strings.keyAchievements,
                style: styles.labelMedium.copyWith(color: palette.accent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                '•  $item',
                style: styles.bodySmall.copyWith(color: palette.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}
