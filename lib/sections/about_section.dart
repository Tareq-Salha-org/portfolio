import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/device.dart';
import '../core/widgets/widgets.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;
    final summary = PortfolioData.summary;

    return ContentSection(
      child: StaggeredGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StaggeredItem(
              index: 0,
              child: SectionHeader(
                eyebrow: strings.eyebrowAbout,
                title: strings.aboutTitle,
                subtitle: strings.aboutSubtitle,
              ),
            ),
            const SizedBox(height: 48),
            Responsive.isMobile(context)
                ? _buildMobile(context, summary)
                : _buildDesktop(context, summary),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, String summary) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: StaggeredItem(
            index: 1,
            child: _buildSummaryCard(context, summary),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(flex: 5, child: _buildFocusGrid(context)),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, String summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredItem(index: 1, child: _buildSummaryCard(context, summary)),
        const SizedBox(height: 24),
        _buildFocusGrid(context),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String summary) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.primary, palette.accent],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            summary,
            style: styles.bodyLarge.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              _MiniStat(
                value: '${PortfolioData.projectCount}',
                label: scope.strings.statProjects,
              ),
              _MiniStat(
                value: '${PortfolioData.experienceCount}',
                label: scope.strings.statExperience,
              ),
              _MiniStat(
                value: '${PortfolioData.totalSkillCount}',
                label: scope.strings.statSkills,
              ),
              _MiniStat(
                value: '${PortfolioData.languages.length}',
                label: scope.strings.statLanguages,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FactChip(icon: Icons.work_outline, label: PortfolioData.role),
              _FactChip(
                icon: Icons.location_on_outlined,
                label: PortfolioData.location,
              ),
              _FactChip(
                icon: Icons.translate,
                label: PortfolioData.languages
                    .map((l) => l.name)
                    .join(' · '),
              ),
              _FactChip(
                icon: Icons.school_outlined,
                label: PortfolioData.education.isNotEmpty
                    ? PortfolioData.education.first.degree
                    : '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<_FocusCardData> _focusData(BuildContext context) {
    return [
      const _FocusCardData(
        icon: Icons.code,
        title: 'RESTful Engineering',
        desc: 'Clean, versioned RESTful APIs on Laravel & PHP',
      ),
      const _FocusCardData(
        icon: Icons.storage_rounded,
        title: 'Database Architecture',
        desc: 'Schema design, query optimization & caching',
      ),
      const _FocusCardData(
        icon: Icons.sync_rounded,
        title: 'Integrations & Real-Time',
        desc: 'Agora Voice, JoFotara e-invoicing, WebSockets',
      ),
      const _FocusCardData(
        icon: Icons.rocket_launch_rounded,
        title: 'Automation & Tooling',
        desc: 'CI/CD pipelines for testing & deployment',
      ),
    ];
  }

  Widget _buildFocusGrid(BuildContext context) {
    final items = _focusData(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 480;
        return GridView.count(
          crossAxisCount: isWide ? 2 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var i = 0; i < items.length; i++)
              StaggeredItem(
                index: i + 2,
                offset: 20,
                child: _FocusCard(data: items[i]),
              ),
          ],
        );
      },
    );
  }
}

class _FactChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FactChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.backgroundAlt,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: palette.textMuted),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.build(
              context,
              13,
              FontWeight.w500,
              color: palette.textSecondary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  final _FocusCardData data;

  const _FocusCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return HoverCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, size: 20, color: palette.primary),
          ),
          const SizedBox(height: 16),
          Text(data.title, style: styles.titleMedium),
          const SizedBox(height: 6),
          Text(
            data.desc,
            style: styles.bodySmall.copyWith(color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}

class _FocusCardData {
  final IconData icon;
  final String title;
  final String desc;

  const _FocusCardData({
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;

  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: palette.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.build(
              context,
              19,
              FontWeight.w800,
              color: palette.primary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: styles.caption.copyWith(color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}
