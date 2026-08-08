import 'package:flutter/material.dart';

import '../core/theme/theme.dart';
import '../core/utils/motion.dart';
import '../core/widgets/grid_background.dart';
import '../core/widgets/svg_icon.dart';

/// A generated, abstract visual for project cards — no fake screenshots.
///
/// Renders a dark engineering surface with a subtle dot grid, the project's
/// top technology as oversized ghost text, real tech icons, and lightweight
/// API/backend motifs (terminal line, database node, route glyphs).
class ProjectVisual extends StatelessWidget {
  final List<String> techStack;
  final String primaryLanguage;
  final Color accent;

  const ProjectVisual({
    super.key,
    required this.techStack,
    required this.primaryLanguage,
    required this.accent,
  });

  static const Map<String, String> _knownIcons = {
    'laravel': 'laravel',
    'php': 'php',
    'mysql': 'mysql',
  };

  List<String> get _iconCandidates {
    final list = <String>[];
    final lower = techStack.map((t) => t.toLowerCase()).toList();
    for (final name in const ['laravel', 'php', 'mysql']) {
      if (lower.any((t) => t.contains(name)) && list.length < 3) {
        list.add(_knownIcons[name]!);
      }
    }
    return list;
  }

  String get _ghostWord {
    final word = techStack.isNotEmpty
        ? techStack.first.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase()
        : 'API';
    return word.length > 8 ? word.substring(0, 8) : word;
  }

  String get _apiRoute {
    final lower = techStack.map((t) => t.toLowerCase()).join(' ');
    if (lower.contains('chat') || lower.contains('websocket')) {
      return 'POST /api/chat/messages';
    }
    if (lower.contains('booking') || lower.contains('orders')) {
      return 'POST /api/bookings';
    }
    if (lower.contains('voice')) {
      return 'POST /api/voice/call';
    }
    if (lower.contains('content') || lower.contains('course')) {
      return 'GET  /api/courses';
    }
    if (lower.contains('invoice')) {
      return 'POST /api/invoices';
    }
    return 'GET  /api/v1/resource';
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final icons = _iconCandidates;

    return Container(
      height: 140,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: palette.codeBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Stack(
        children: [
          // Subtle engineering grid.
          GridBackground(spacing: 26),

          // Ghost project technology word.
          Positioned(
            right: -18,
            bottom: -26,
            child: Text(
              _ghostWord,
              style: TextStyle(
                fontSize: 74,
                fontWeight: FontWeight.w800,
                color: accent.withValues(alpha: 0.10),
                letterSpacing: 1,
              ),
            ),
          ),

          // Soft radial glow.
          Positioned(
            bottom: -20,
            left: -16,
            child: Container(
              width: 150,
              height: 60,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    accent.withValues(alpha: 0.22),
                    accent.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // Accent top hairline.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withValues(alpha: 0)],
                ),
              ),
            ),
          ),

          // Terminal dots.
          Positioned(
            top: 14,
            left: 16,
            child: Row(
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: palette.borderStrong,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),

          // Technology icons.
          Positioned(
            top: 12,
            right: 14,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final icon in icons)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: palette.surfaceElevated.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: palette.border),
                      ),
                      child: Center(
                        child: AppSvgIcon(name: icon, width: 16, height: 16),
                      ),
                    ),
                  ),
                if (icons.isEmpty)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: palette.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: palette.border),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.code,
                        size: 16,
                        color: palette.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // API route glyph — backend identity.
          Positioned(
            bottom: 14,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: palette.background.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: palette.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.terminal, size: 12, color: accent),
                  const SizedBox(width: 6),
                  Text(
                    _apiRoute,
                    style: AppTextStyles.build(
                      context,
                      11.5,
                      FontWeight.w600,
                      color: palette.textSecondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const _PulseDot(),
                ],
              ),
            ),
          ),

          // Database node glyph — bottom end.
          Positioned(
            right: 14,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: palette.surfaceElevated.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: palette.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.storage_rounded, size: 12, color: accent),
                  const SizedBox(width: 5),
                  Text(
                    primaryLanguage,
                    style: AppTextStyles.build(
                      context,
                      11.5,
                      FontWeight.w600,
                      color: palette.textSecondary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A tiny pulsing "live" dot — signals an active backend endpoint. Uses a
/// single repeating controller; disabled for reduced-motion users.
class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (!Motion.reduceMotion) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 1;
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
      opacity: Tween<double>(
        begin: 0.35,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: palette.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: palette.accent.withValues(alpha: 0.6),
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}
