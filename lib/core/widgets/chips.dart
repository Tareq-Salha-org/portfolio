import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A small rounded badge used for technologies and skill items.
class TechChip extends StatelessWidget {
  final String label;
  final Color? accent;
  final IconData? icon;

  const TechChip({super.key, required this.label, this.accent, this.icon});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final color = accent ?? palette.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withAlpha(16),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: color.withAlpha(55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.build(
              context,
              12.5,
              FontWeight.w600,
              color: color,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill-shaped label used inside the hero terminal.
class TerminalLine extends StatelessWidget {
  final String prompt;
  final String value;
  final bool highlight;

  const TerminalLine({
    super.key,
    required this.prompt,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final accent = highlight ? palette.accent : palette.textPrimary;
    final styles = AppTextStyles.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$',
            style: styles.code.copyWith(
              color: palette.primaryStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Text(prompt, style: styles.code.copyWith(color: palette.textMuted)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: styles.code.copyWith(
                color: accent,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
