import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/device.dart';
import '../core/utils/motion.dart';
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
      child: StaggeredGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StaggeredItem(
              index: 0,
              child: SectionHeader(
                eyebrow: strings.eyebrowExperience,
                title: strings.experienceTitle,
                subtitle: strings.experienceSubtitle,
              ),
            ),
            const SizedBox(height: 48),
            for (var i = 0; i < _experiences.length; i++)
              StaggeredItem(
                index: i + 1,
                offset: 28,
                child: _TimelineItem(
                  experience: _experiences[i],
                  isLast: i == _experiences.length - 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Experience experience;
  final bool isLast;

  const _TimelineItem({required this.experience, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final card = _ExperienceCard(experience: experience, isMobile: isMobile);

    if (isMobile) {
      // Compact vertical rail on phones so the timeline stays elegant without
      // consuming horizontal space.
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TimelineRail(compact: true, isLast: isLast),
            const SizedBox(width: 14),
            Expanded(child: card),
          ],
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineRail(compact: false, isLast: isLast),
          const SizedBox(width: 28),
          Expanded(child: card),
        ],
      ),
    );
  }
}

/// Vertical rail with a pulsing node that pops in and a line that draws
/// downward when the rail enters the viewport.
class _TimelineRail extends StatefulWidget {
  final bool compact;
  final bool isLast;

  const _TimelineRail({required this.compact, required this.isLast});

  @override
  State<_TimelineRail> createState() => _TimelineRailState();
}

class _TimelineRailState extends State<_TimelineRail>
    with SingleTickerProviderStateMixin {
  static int _counter = 0;
  final int _id = _counter++;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.duration(const Duration(milliseconds: 900)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final railWidth = widget.compact ? 26.0 : 40.0;
    final nodeSize = widget.compact ? 12.0 : 16.0;

    // One detector for the whole rail so even the last item's node pops in.
    return SizedBox(
      width: railWidth,
      child: VisibilityDetector(
        key: Key('timeline-rail-$_id'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.25) {
            if (!_controller.isAnimating && _controller.value < 0.02) {
              _controller.forward();
            }
          } else if (info.visibleFraction < 0.05) {
            _controller.reset();
          }
        },
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final scale = 0.5 + 0.5 * _controller.value;
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: 0.3 + 0.7 * _controller.value,
                    child: Container(
                      width: nodeSize,
                      height: nodeSize,
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
                          width: nodeSize * 0.38,
                          height: nodeSize * 0.38,
                          decoration: BoxDecoration(
                            color: palette.background,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (!widget.isLast)
              Expanded(
                child: CustomPaint(
                  painter: _LinePainter(
                    t: _controller.value,
                    top: palette.primary,
                    bottom: palette.border,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Draws a vertical gradient line that grows from the top as `t` goes 0 → 1,
/// with a small accent dot at the leading edge.
class _LinePainter extends CustomPainter {
  final double t;
  final Color top;
  final Color bottom;

  _LinePainter({required this.t, required this.top, required this.bottom});

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0.01) return;
    final centerX = size.width / 2;
    final lineHeight = size.height * t;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [top.withValues(alpha: 0.75), bottom],
      ).createShader(Rect.fromLTWH(0, 0, size.width, lineHeight));
    canvas.drawRect(Rect.fromLTWH(centerX - 1, 0, 2, lineHeight), paint);
    // Leading accent dot at the tip of the growing line.
    if (lineHeight > 1) {
      canvas.drawCircle(
        Offset(centerX, lineHeight),
        2.5,
        Paint()..color = top.withValues(alpha: 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) => oldDelegate.t != t;
}

class _ExperienceCard extends StatelessWidget {
  final Experience experience;
  final bool isMobile;

  const _ExperienceCard({required this.experience, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);

    return HoverCard(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(experience.role, style: styles.titleLarge),
          const SizedBox(height: 8),
          if (isMobile) ...[
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
                    style: styles.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 15,
                  color: palette.textMuted,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    experience.location,
                    style: styles.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _DateBadge(dateRange: experience.dateRange),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Row(
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
                          style: styles.bodySmall.copyWith(
                            color: palette.textSecondary,
                          ),
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
                          style: styles.bodySmall.copyWith(
                            color: palette.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _DateBadge(dateRange: experience.dateRange),
              ],
            ),
          ],
          const SizedBox(height: 20),
          for (final item in experience.responsibilities)
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
                      style: styles.bodySmall.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (experience.achievements.isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildAchievements(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);
    final items = experience.achievements;

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
                scope.strings.keyAchievements,
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

class _DateBadge extends StatelessWidget {
  final String dateRange;

  const _DateBadge({required this.dateRange});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: palette.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: palette.primary.withValues(alpha: 0.35)),
      ),
      child: Text(
        dateRange,
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
}
