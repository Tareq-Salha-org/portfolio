import 'dart:math' as math;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../utils/motion.dart';

/// Thin Laravel-red scroll progress line pinned to the top of the page.
///
/// Listens to a [ValueListenable] progress value (0..1) so only the bar
/// rebuilds on scroll — the rest of the page never does.
class ScrollProgressBar extends StatelessWidget {
  final ValueListenable<double> progress;

  const ScrollProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 3,
      child: IgnorePointer(
        child: RepaintBoundary(
          child: ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (context, value, _) => Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: value.clamp(0.0, 1.0),
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [palette.primary, palette.accent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: palette.primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Moves a child relative to the page scroll — slower than the foreground,
/// producing a subtle depth/parallax effect, with an optional fade-out.
///
/// The effect only acts over the first [range] pixels of scrolling and clamps
/// afterwards, so it never over-travels or looks disorienting.
class ParallaxElement extends StatelessWidget {
  final ScrollController controller;
  final Widget child;

  /// Fraction of the scroll offset applied to the child (opposite direction).
  final double factor;

  /// Scroll distance (px) over which the effect ramps up.
  final double range;

  /// Whether the child fades out while scrolling through [range].
  final bool fadeOut;

  const ParallaxElement({
    super.key,
    required this.controller,
    required this.child,
    this.factor = 0.22,
    this.range = 460,
    this.fadeOut = true,
  });

  @override
  Widget build(BuildContext context) {
    if (Motion.reduceMotion) return child;
    // The `child:` slot keeps the subtree built once — only the transform and
    // opacity change on scroll, so the content never rebuilds per tick.
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        final offset = controller.hasClients
            ? controller.offset.clamp(0.0, range)
            : 0.0;
        final progress = range == 0 ? 0.0 : offset / range;
        return Opacity(
          opacity: fadeOut ? 1 - progress * 0.9 : 1,
          child: Transform.translate(
            offset: Offset(0, -offset * factor),
            child: child,
          ),
        );
      },
    );
  }
}

/// Slowly floats a decorative child up and down, indefinitely.
///
/// For hero ornaments only — keep the count low (2–3 per page). Disabled for
/// reduced-motion users (renders a static frame).
class FloatingElement extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration duration;
  final double phase;

  const FloatingElement({
    super.key,
    required this.child,
    this.amplitude = 8,
    this.duration = const Duration(milliseconds: 5200),
    this.phase = 0,
  });

  @override
  State<FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends State<FloatingElement>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (!Motion.reduceMotion) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final y =
              math.sin(_controller.value * math.pi * 2 + widget.phase) *
              widget.amplitude;
          return Transform.translate(offset: Offset(0, y), child: child);
        },
        child: widget.child,
      ),
    );
  }
}
