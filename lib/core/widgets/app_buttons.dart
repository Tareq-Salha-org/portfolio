import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expanded;
  final double? iconSize;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expanded = false,
    this.iconSize = 18,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isPrimary = widget.variant == AppButtonVariant.primary;

    final Color bg;
    final Color fg;
    final Color border;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        bg = palette.primary;
        fg = palette.onPrimary;
        border = palette.primary;
      case AppButtonVariant.secondary:
        bg = Colors.transparent;
        fg = palette.primary;
        border = palette.primary.withAlpha(170);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeOut,
          width: widget.expanded ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          transform: Matrix4.translationValues(
            0,
            _pressed ? 1 : (_hovered ? -1 : 0),
            0,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: border),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: (isPrimary ? palette.primary : palette.accent)
                          .withAlpha(35),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: widget.iconSize, color: fg),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: AppTextStyles.build(
                  context,
                  15.5,
                  FontWeight.w600,
                  color: fg,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact round icon button used in the header and footer for social links.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            onTap: onTap,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: palette.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(color: palette.border),
              ),
              child: Icon(icon, size: 18, color: palette.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
