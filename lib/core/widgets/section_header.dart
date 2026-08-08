import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Shared section heading: small eyebrow, prominent title and subtitle.
class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Color? accent;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final styles = AppTextStyles.of(context);
    final palette = AppPalette.of(context);
    final accent = this.accent ?? palette.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: accent.withAlpha(18),
            borderRadius: BorderRadius.circular(AppRadius.tiny),
            border: Border.all(color: accent.withAlpha(45)),
          ),
          child: Text(
            eyebrow,
            style: AppTextStyles.build(
              context,
              12,
              FontWeight.w700,
              color: accent,
              height: 1.2,
              letterSpacing: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(title, style: styles.headline),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle,
              style: styles.bodyLarge.copyWith(color: palette.textSecondary),
            ),
          ),
        ],
      ],
    );
  }
}

/// A subtle decorative divider for moments that need separation.
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Center(
      child: Container(
        width: 96,
        height: 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(
            colors: [
              palette.primary.withAlpha(0),
              palette.primary.withAlpha(90),
            ],
          ),
        ),
      ),
    );
  }
}
