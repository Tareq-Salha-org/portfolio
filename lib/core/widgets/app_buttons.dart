import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'svg_icon.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expanded;
  final double? iconSize;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expanded = false,
    this.iconSize = 18,
    this.loading = false,
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
      cursor: widget.loading
          ? SystemMouseCursors.wait
          : SystemMouseCursors.click,
      onEnter: widget.loading ? null : (_) => setState(() => _hovered = true),
      onExit: widget.loading ? null : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: widget.loading
            ? null
            : (_) => setState(() => _pressed = true),
        onTapCancel: widget.loading
            ? null
            : () => setState(() => _pressed = false),
        onTapUp: widget.loading
            ? null
            : (_) => setState(() => _pressed = false),
        onTap: widget.loading ? null : widget.onTap,
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
            color: widget.loading ? bg.withValues(alpha: 0.75) : bg,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: border),
            boxShadow: _hovered && !widget.loading
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
              if (widget.loading) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(fg),
                  ),
                ),
                const SizedBox(width: 10),
              ] else if (widget.icon != null) ...[
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
class AppIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final double size;
  final String? svg;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.size = 42,
    this.svg,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final hovered = _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              curve: Curves.easeOut,
              width: widget.size,
              height: widget.size,
              transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
              decoration: BoxDecoration(
                color: hovered ? palette.primarySoft : palette.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(
                  color: hovered
                      ? palette.primary.withAlpha(110)
                      : palette.border,
                ),
              ),
              child: widget.svg != null
                  ? AppSvgIcon(
                      name: widget.svg!,
                      width: 20,
                      height: 20,
                      color: hovered
                          ? palette.primary
                          : palette.textSecondary,
                    )
                  : Icon(
                      widget.icon,
                      size: 18,
                      color: hovered
                          ? palette.primary
                          : palette.textSecondary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
