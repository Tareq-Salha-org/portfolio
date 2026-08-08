import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../animations/animations.dart';
import '../theme/theme.dart';
import '../utils/motion.dart';

/// Fades, slides and optionally scales content in once it enters the viewport.
///
/// Uses [VisibilityDetector] so animations only run when visible and are not
/// re-triggered on rebuilds. [delay] staggers siblings that share a section.
class AnimatedReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offset;
  final double scaleFrom;
  final Axis direction;

  const AnimatedReveal({
    super.key,
    required this.child,
    this.duration = AppDurations.normal,
    this.delay = Duration.zero,
    this.offset = 24,
    this.scaleFrom = 1,
    this.direction = Axis.vertical,
  });

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal> {
  static int _counter = 0;
  final int _id = _counter++;

  bool _visible = false;
  bool _started = false;

  void _trigger() {
    if (_started) return;
    _started = true;
    if (widget.delay > Duration.zero) {
      Future<void>.delayed(Motion.duration(widget.delay), () {
        if (mounted) setState(() => _visible = true);
      });
    } else {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduceMotion) {
      return widget.child;
    }
    return VisibilityDetector(
      key: Key('reveal-$_id'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.08 && !_visible) _trigger();
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _visible ? 1 : 0),
        duration: Motion.duration(widget.duration),
        curve: MotionCurves.gentle,
        child: widget.child,
        builder: (context, value, child) {
          final dx = widget.direction == Axis.horizontal
              ? widget.offset * (1 - value)
              : 0.0;
          final dy = widget.direction == Axis.vertical
              ? widget.offset * (1 - value)
              : 0.0;
          final scale = 1 - (1 - widget.scaleFrom) * (1 - value);
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(dx, dy),
              child: Transform.scale(scale: scale, child: child),
            ),
          );
        },
      ),
    );
  }
}

/// Wraps a card with an animated hover elevation + border highlight.
///
/// On desktop a hover lifts the card and adds a Laravel-red glow; on touch
/// devices a subtle press-scale provides feedback instead. [onHoverChanged]
/// lets parents animate extra content (icons, badges) while hovered.
class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<bool>? onHoverChanged;

  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius,
    this.padding,
    this.onHoverChanged,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;
  bool _pressed = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
    widget.onHoverChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final radius = widget.radius ?? BorderRadius.circular(AppRadius.card);

    final card = AnimatedContainer(
      duration: AppDurations.fast,
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0)
        ..multiply(
          Matrix4.diagonal3Values(
            _pressed ? 0.985 : 1,
            _pressed ? 0.985 : 1,
            1,
          ),
        ),
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
                  color: palette.primary.withValues(alpha: 0.16),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: widget.child,
    );

    Widget content = MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: card,
    );

    if (widget.onTap != null) {
      content = GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: content,
      );
    }
    return content;
  }
}
