import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../animations/animations.dart';
import '../utils/motion.dart';

/// Drives a shared reveal animation for a group of children.
///
/// A single [AnimationController] is used for the whole group (not one per
/// child), so staggered grids and lists stay cheap. [StaggeredItem]s inside
/// read the shared progress and slice it into per-item intervals.
///
/// The animation starts when the group enters the viewport and replays when it
/// is scrolled fully out of view (use [replay] = false to reveal only once).
class StaggeredGroup extends StatefulWidget {
  final Widget child;

  /// Total animation budget for the whole group.
  final Duration duration;

  /// Fraction of the total budget spent before each consecutive item starts.
  final double intervalFraction;

  /// Fraction of the total budget each item's own animation runs for.
  final double itemFraction;

  /// Whether the group re-animates every time it re-enters the viewport.
  final bool replay;

  const StaggeredGroup({
    super.key,
    required this.child,
    this.duration = MotionTokens.reveal,
    this.intervalFraction = 0.12,
    this.itemFraction = 0.45,
    this.replay = true,
  });

  @override
  State<StaggeredGroup> createState() => _StaggeredGroupState();
}

class _StaggeredGroupState extends State<StaggeredGroup>
    with SingleTickerProviderStateMixin {
  static int _counter = 0;
  final int _id = _counter++;

  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.duration(widget.duration),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: MotionCurves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibility(double fraction) {
    if (fraction > 0.10) {
      if (!_controller.isAnimating && _controller.value == 0) {
        _controller.forward();
      }
    } else if (fraction < 0.03 && widget.replay && _controller.value > 0.02) {
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduceMotion) {
      return widget.child;
    }
    return _StaggerScope(
      progress: _progress,
      intervalFraction: widget.intervalFraction,
      itemFraction: widget.itemFraction,
      child: VisibilityDetector(
        key: Key('stagger-group-$_id'),
        onVisibilityChanged: (info) => _onVisibility(info.visibleFraction),
        child: widget.child,
      ),
    );
  }
}

/// Inherited scope handing the shared group progress + timing to [StaggeredItem]s.
class _StaggerScope extends InheritedWidget {
  final Animation<double> progress;
  final double intervalFraction;
  final double itemFraction;

  const _StaggerScope({
    required this.progress,
    required this.intervalFraction,
    required this.itemFraction,
    required super.child,
  });

  static _StaggerScopeData? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_StaggerScope>();
    if (scope == null) return null;
    return _StaggerScopeData(
      progress: scope.progress,
      intervalFraction: scope.intervalFraction,
      itemFraction: scope.itemFraction,
    );
  }

  @override
  bool updateShouldNotify(_StaggerScope oldWidget) =>
      progress != oldWidget.progress ||
      intervalFraction != oldWidget.intervalFraction ||
      itemFraction != oldWidget.itemFraction;
}

class _StaggerScopeData {
  final Animation<double> progress;
  final double intervalFraction;
  final double itemFraction;

  const _StaggerScopeData({
    required this.progress,
    required this.intervalFraction,
    required this.itemFraction,
  });
}

/// A single staggered child inside a [StaggeredGroup].
///
/// Fades and slides in on its own slice of the group's shared animation.
class StaggeredItem extends StatelessWidget {
  final int index;
  final Widget child;
  final double offset;
  final Axis direction;

  const StaggeredItem({
    super.key,
    required this.index,
    required this.child,
    this.offset = 26,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _StaggerScope.of(context);
    if (scope == null || Motion.reduceMotion) {
      return child;
    }

    final start = (index * scope.intervalFraction).clamp(0.0, 0.85);
    final itemEnd = (start + scope.itemFraction).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: scope.progress,
      curve: Interval(start, itemEnd, curve: MotionCurves.gentle),
    );

    final dx = direction == Axis.horizontal ? offset : 0.0;
    final dy = direction == Axis.vertical ? offset : 0.0;

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(dx, dy),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
