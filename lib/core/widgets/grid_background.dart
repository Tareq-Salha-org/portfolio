import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A subtle dotted engineering grid used behind the hero section.
/// Drawn once per frame — cheap, static, and respectful of DP size.
class GridBackground extends StatelessWidget {
  final double spacing;
  final double dotRadius;
  final Widget? child;

  const GridBackground({
    super.key,
    this.spacing = 32,
    this.dotRadius = 1,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return CustomPaint(
      painter: _GridPainter(
        color: palette.gridLine,
        spacing: spacing,
        dotRadius: dotRadius,
      ),
      child: child,
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double dotRadius;

  _GridPainter({
    required this.color,
    required this.spacing,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (double x = 0; x <= size.width; x += spacing) {
      for (double y = 0; y <= size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) =>
      color != oldDelegate.color ||
      spacing != oldDelegate.spacing ||
      dotRadius != oldDelegate.dotRadius;
}

/// A soft radial glow behind a section, drawn without blur layers.
class GlowBackdrop extends StatelessWidget {
  final Color color;
  final double opacity;
  final double size;

  const GlowBackdrop({
    super.key,
    required this.color,
    this.opacity = 0.10,
    this.size = 420,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _GlowPainter(color: color, opacity: opacity, size: size),
        ),
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final double size;

  _GlowPainter({
    required this.color,
    required this.opacity,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height * 0.35);
    final rect = Rect.fromCircle(center: center, radius: size);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawRect(Offset.zero & canvasSize, paint);
  }

  @override
  bool shouldRepaint(_GlowPainter oldDelegate) => color != oldDelegate.color;
}
