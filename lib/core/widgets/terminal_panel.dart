import 'package:flutter/material.dart';

import '../localization/app_locale.dart';
import '../theme/theme.dart';
import '../utils/motion.dart';
import 'chips.dart';

/// A code/terminal panel used as the hero visual.
///
/// Displays information that is fully supported by the portfolio source.
class TerminalPanel extends StatelessWidget {
  final AppLocale locale;

  const TerminalPanel({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final strings = AppStrings.of(locale);

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: palette.glow,
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.panel - 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleBar(context),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: palette.codeBackground),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroLine(
                    prompt: '>',
                    value: strings.termStatus,
                    colors: palette.success,
                  ),
                  const SizedBox(height: 6),
                  HeroLine(
                    prompt: strings.termWho,
                    value: strings.termIdentity,
                    highlighted: true,
                  ),
                  HeroLine(
                    prompt: strings.termStack,
                    value: strings.termStackValue,
                  ),
                  HeroLine(
                    prompt: strings.termFocus,
                    value: strings.termFocusValue,
                  ),
                  const SizedBox(height: 4),
                  const _BlinkingCursor(),
                  const SizedBox(height: 12),
                  _buildStatusRow(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: palette.backgroundAlt,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: Row(
        children: [
          for (final color in const [
            Color(0xFFFF5F57),
            Color(0xFFFEBC2E),
            Color(0xFF28C840),
          ]) ...[
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ],
          const SizedBox(width: 10),
          Text(
            'backend@portfolio ~',
            style: styles.caption.copyWith(color: palette.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tech in ['Laravel', 'PHP', 'MySQL', 'REST API'])
          TechChip(label: tech),
      ],
    );
  }
}

class HeroLine extends StatelessWidget {
  final String prompt;
  final String value;
  final bool highlighted;
  final Color? colors;

  const HeroLine({
    super.key,
    required this.prompt,
    required this.value,
    this.highlighted = false,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prompt,
            style: styles.code.copyWith(
              color: palette.primaryStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: styles.code.copyWith(
                color:
                    colors ??
                    (highlighted ? palette.textPrimary : palette.textMuted),
                fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small terminal block cursor that pulses softly.
///
/// Disabled when the user prefers reduced motion.
class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (!Motion.reduceMotion) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 0.4;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 9,
        height: 18,
        decoration: BoxDecoration(
          color: palette.primary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
