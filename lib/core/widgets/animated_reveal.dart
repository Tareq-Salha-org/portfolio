import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../theme/theme.dart';
import '../utils/motion.dart';

/// Fades and slides content in once it enters the viewport.
///
/// Uses [VisibilityDetector] so animations only run when visible and are not
/// re-triggered on rebuilds.
class AnimatedReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final Axis direction;

  const AnimatedReveal({
    super.key,
    required this.child,
    this.duration = AppDurations.normal,
    this.offset = 24,
    this.direction = Axis.vertical,
  });

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    if (Motion.reduceMotion) {
      return widget.child;
    }
    return VisibilityDetector(
      key: Key('reveal-${widget.child.hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.08 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _visible ? 1 : 0),
        duration: Motion.duration(widget.duration),
        curve: Curves.easeOutCubic,
        child: widget.child,
        builder: (context, value, child) {
          final dx = widget.direction == Axis.horizontal
              ? widget.offset * (1 - value)
              : 0.0;
          final dy = widget.direction == Axis.vertical
              ? widget.offset * (1 - value)
              : 0.0;
          return Opacity(
            opacity: value,
            child: Transform.translate(offset: Offset(dx, dy), child: child),
          );
        },
      ),
    );
  }
}

/// Wraps a card with an animated hover elevation + border highlight.
class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? padding;

  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius,
    this.padding,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final radius = widget.radius ?? BorderRadius.circular(AppRadius.card);

    final card = AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: _hovered ? palette.surfaceElevated : palette.surface,
        borderRadius: radius,
        border: Border.all(
          color: _hovered ? palette.primary.withAlpha(80) : palette.border,
        ),
        boxShadow: _hovered
            ? [
                BoxShadow(
                  color: palette.primary.withAlpha(20),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: widget.child,
    );

    if (widget.onTap == null) {
      return MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: card,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(onTap: widget.onTap, child: card),
    );
  }
}
