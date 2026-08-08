import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../animations/animations.dart';
import '../theme/theme.dart';
import '../utils/device.dart';
import '../utils/motion.dart';

/// Ambient technical background for the whole page.
///
/// Paints a backend-flavoured network — drifting nodes, faint connections and
/// occasional API-request particles in the Laravel-red accent — plus a sparse
/// engineering grid and a soft glow. It is drawn once per frame by a single
/// [CustomPainter], sits behind all content (`IgnorePointer`) and is wrapped
/// in a [RepaintBoundary] so repaints never leak into the rest of the tree.
///
/// Density is tuned per device: mobile gets far fewer nodes, connections and
/// particles so low-end phones stay smooth. When the user prefers reduced
/// motion the scene is rendered as a single static frame and parallax is
/// disabled.
class AnimatedBackground extends StatefulWidget {
  /// The page's main scroll controller, used for subtle parallax.
  final ScrollController? scrollController;

  const AnimatedBackground({super.key, this.scrollController});

  /// Padding above/below the viewport so the parallax shift never reveals a
  /// gap. The page positions this widget in a taller-than-screen box.
  static const double parallaxPad = 300;

  /// Maximum downward shift of the background relative to the scroll offset.
  static const double _parallaxMax = 220;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  static const int _maxNodes = 28;

  late final AnimationController _controller;
  late final List<_Node> _nodes = _generateNodes();
  late final List<_Edge> _edges = _generateEdges();
  late final List<int> _particleEdges = _pickParticleEdges();

  List<_Node> _generateNodes() {
    final rng = math.Random(2026);
    return List.generate(_maxNodes, (i) {
      return _Node(
        base: Offset(
          0.03 + rng.nextDouble() * 0.94,
          0.03 + rng.nextDouble() * 0.94,
        ),
        radius: 1.4 + rng.nextDouble() * 2.0,
        phase: rng.nextDouble() * math.pi * 2,
        speed: 0.35 + rng.nextDouble() * 0.6,
        isPrimary: rng.nextDouble() < 0.28,
      );
    });
  }

  List<_Edge> _generateEdges() {
    final edges = <_Edge>[];
    // Connect each node to its two nearest neighbours within a fraction of the
    // screen. Fraction-space means the topology survives any viewport size.
    for (var i = 0; i < _nodes.length; i++) {
      final candidates = <(double, int)>[];
      for (var j = 0; j < _nodes.length; j++) {
        if (i == j) continue;
        final d = (_nodes[i].base - _nodes[j].base).distance;
        if (d < 0.26) candidates.add((d, j));
      }
      candidates.sort((a, b) => a.$1.compareTo(b.$1));
      for (final (_, j) in candidates.take(2)) {
        edges.add(_Edge(i, j));
      }
    }
    return edges;
  }

  List<int> _pickParticleEdges() {
    if (_edges.isEmpty) return const [];
    final rng = math.Random(99);
    final indices = List.generate(_edges.length, (i) => i)..shuffle(rng);
    return indices.take(6).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.duration(MotionTokens.ambient),
    );
    if (!Motion.reduceMotion) {
      _controller.repeat();
    } else {
      _controller.value = 0.4;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _scrollY() {
    if (Motion.reduceMotion) return 0;
    final controller = widget.scrollController;
    if (controller == null || !controller.hasClients) return 0;
    return math.min(controller.offset * 0.10, AnimatedBackground._parallaxMax);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final density = _Density(
      nodeCount: isMobile ? 10 : (isTablet ? 16 : _maxNodes),
      edgeDistance: isMobile ? 0.20 : (isTablet ? 0.22 : 0.26),
      neighbors: isMobile ? 1 : 2,
      particleCount: isMobile ? 1 : (isTablet ? 2 : 4),
      gridSpacing: isMobile ? 46 : 36,
    );

    final listenable = widget.scrollController == null
        ? _controller
        : Listenable.merge([_controller, widget.scrollController!]);

    return RepaintBoundary(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: listenable,
          builder: (context, _) {
            // The real viewport drives node layout (the canvas is padded for
            // the parallax shift); only the drawing offset uses the padding.
            final viewport = MediaQuery.sizeOf(context);
            return CustomPaint(
              size: viewport,
              painter: _NetworkPainter(
                nodes: _nodes,
                edges: _edges,
                particleEdges: _particleEdges,
                density: density,
                viewport: viewport,
                t: _controller.value,
                scrollY: _scrollY(),
                primary: palette.primary,
                nodeColor: palette.textMuted,
                gridColor: palette.gridLine,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Density {
  final int nodeCount;
  final double edgeDistance;
  final int neighbors;
  final int particleCount;
  final double gridSpacing;

  const _Density({
    required this.nodeCount,
    required this.edgeDistance,
    required this.neighbors,
    required this.particleCount,
    required this.gridSpacing,
  });
}

class _Node {
  final Offset base;
  final double radius;
  final double phase;
  final double speed;
  final bool isPrimary;

  const _Node({
    required this.base,
    required this.radius,
    required this.phase,
    required this.speed,
    required this.isPrimary,
  });
}

class _Edge {
  final int a;
  final int b;

  const _Edge(this.a, this.b);
}

class _NetworkPainter extends CustomPainter {
  final List<_Node> nodes;
  final List<_Edge> edges;
  final List<int> particleEdges;
  final _Density density;

  /// The real viewport — node topology is laid out against this rather than
  /// the padded canvas, so the network fills the visible screen.
  final Size viewport;
  final double t;
  final double scrollY;
  final Color primary;
  final Color nodeColor;
  final Color gridColor;

  _NetworkPainter({
    required this.nodes,
    required this.edges,
    required this.particleEdges,
    required this.density,
    required this.viewport,
    required this.t,
    required this.scrollY,
    required this.primary,
    required this.nodeColor,
    required this.gridColor,
  });

  static const double _twoPi = math.pi * 2;

  Offset _drift(_Node node) {
    final angle = _twoPi * (t * node.speed) + node.phase;
    final dx = math.sin(angle) * viewport.width * 0.008;
    final dy = math.cos(angle * 0.7) * viewport.height * 0.008;
    return Offset(
      node.base.dx * viewport.width + dx,
      node.base.dy * viewport.height + dy + scrollY,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final count = math.min(density.nodeCount, nodes.length);

    // Soft radial glow behind the hero area.
    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              primary.withValues(alpha: 0.055),
              primary.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(viewport.width * 0.2, 140 + scrollY),
              radius: viewport.width * 0.55,
            ),
          );
    canvas.drawRect(Offset(0, 0) & Size(size.width, size.height), glowPaint);

    // Sparse engineering grid (coarser on mobile for less per-frame work).
    final gridPaint = Paint()..color = gridColor;
    final spacing = density.gridSpacing;
    for (var x = 0.0; x <= size.width; x += spacing) {
      for (var y = 0.0; y <= size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y + scrollY), 1, gridPaint);
      }
    }

    // Connections — only between nodes of the current density.
    final positions = List<Offset>.generate(count, (i) => _drift(nodes[i]));
    final connectionPaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (final edge in edges) {
      if (edge.a >= count || edge.b >= count) continue;
      final a = positions[edge.a];
      final b = positions[edge.b];
      if ((a - b).distance > density.edgeDistance * viewport.shortestSide) {
        continue;
      }
      final isPrimaryEdge = nodes[edge.a].isPrimary || nodes[edge.b].isPrimary;
      connectionPaint.color = primary.withValues(
        alpha: isPrimaryEdge ? 0.10 : 0.05,
      );
      canvas.drawLine(a, b, connectionPaint);
    }

    // Nodes.
    for (var i = 0; i < count; i++) {
      final node = nodes[i];
      final center = positions[i];
      final pulse = 1 + 0.22 * math.sin(_twoPi * t * 1.2 + node.phase);
      final radius = node.radius * pulse;

      if (node.isPrimary) {
        final halo = Paint()..color = primary.withValues(alpha: 0.14);
        canvas.drawCircle(center, radius * 2.6, halo);
        final fill = Paint()..color = primary.withValues(alpha: 0.65);
        canvas.drawCircle(center, radius, fill);
      } else {
        final fill = Paint()..color = nodeColor.withValues(alpha: 0.32);
        canvas.drawCircle(center, radius, fill);
      }
    }

    // Request particles travelling along selected connections.
    if (Motion.reduceMotion ||
        particleEdges.isEmpty ||
        density.particleCount == 0) {
      return;
    }
    final particlePaint = Paint();
    var drawn = 0;
    for (final edgeIndex in particleEdges) {
      if (drawn >= density.particleCount) break;
      final edge = edges[edgeIndex];
      if (edge.a >= count || edge.b >= count) continue;
      final a = positions[edge.a];
      final b = positions[edge.b];
      final dist = (a - b).distance;
      if (dist > density.edgeDistance * viewport.shortestSide) continue;

      final speed = 0.10 + (edgeIndex % 3) * 0.04;
      final frac = (t * speed * 2 + (edgeIndex % 5) * 0.17) % 1.0;

      // Soft trail behind the leading dot.
      for (var k = 1; k <= 3; k++) {
        final trailFrac = ((frac - k * 0.02) % 1.0).clamp(0.0, 1.0);
        particlePaint.color = primary.withValues(alpha: 0.30 - k * 0.08);
        canvas.drawCircle(
          Offset.lerp(a, b, trailFrac)!,
          2.4 - k * 0.5,
          particlePaint,
        );
      }

      particlePaint.color = primary.withValues(alpha: 0.9);
      canvas.drawCircle(Offset.lerp(a, b, frac)!, 2.6, particlePaint);
      drawn++;
    }
  }

  @override
  bool shouldRepaint(_NetworkPainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.scrollY != scrollY ||
      oldDelegate.primary != primary ||
      oldDelegate.density.nodeCount != density.nodeCount;
}
