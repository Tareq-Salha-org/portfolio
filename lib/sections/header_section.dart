import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../core/widgets/widgets.dart';

/// Sticky header bar with logo, desktop nav, GitHub action and theme toggle.
/// Switches to a compact bar with a menu button below desktop width.
///
/// Reacts to scrolling: at the top it is fully transparent and blends into the
/// hero; once scrolled it shrinks slightly, gains a glass blur (desktop), a
/// bottom border and a soft shadow. The transition is animated, never a jump.
class HeaderSection extends StatelessWidget {
  final bool scrolled;
  final String activeSection;
  final ValueChanged<String> onNavigate;
  final VoidCallback onMenuPressed;

  const HeaderSection({
    super.key,
    required this.scrolled,
    required this.activeSection,
    required this.onNavigate,
    required this.onMenuPressed,
  });

  static const double _height = 68;
  static const double _compactHeight = 60;

  static const List<String> _navKeys = [
    'about',
    'skills',
    'experience',
    'projects',
    'contact',
  ];

  String _labelFor(BuildContext context, String key) {
    final s = AppScope.of(context).strings;
    switch (key) {
      case 'about':
        return s.navAbout;
      case 'skills':
        return s.navSkills;
      case 'experience':
        return s.navExperience;
      case 'projects':
        return s.navProjects;
      case 'contact':
        return s.navContact;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final scope = AppScope.of(context);
    final isCompact = !Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    final toggleTheme = _Toggle(
      icon: scope.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      tooltip: scope.isDark ? 'Light mode' : 'Dark mode',
      onTap: scope.toggleTheme,
    );

    final bar = AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
      height: scrolled ? _compactHeight : _height,
      decoration: BoxDecoration(
        color: scrolled
            ? palette.background.withValues(alpha: isMobile ? 0.94 : 0.78)
            : Colors.transparent,
        border: scrolled
            ? Border(bottom: BorderSide(color: palette.border))
            : null,
        boxShadow: scrolled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? 14 : 28),
        child: Row(
          children: [
            // Flexible so the brand name can ellipsize instead of overflowing
            // on narrow phones (e.g. 320px).
            Flexible(
              child: _Logo(
                text: PortfolioData.fullName,
                subtitle: PortfolioData.role,
                onTap: () => onNavigate('home'),
              ),
            ),
            const Spacer(),
            if (isCompact) ...[
              toggleTheme,
              const SizedBox(width: 6),
              _Toggle(icon: Icons.menu, tooltip: 'Menu', onTap: onMenuPressed),
            ] else ...[
              for (final key in _navKeys)
                _NavLabel(
                  label: _labelFor(context, key),
                  isActive: activeSection == key,
                  onTap: () => onNavigate(key),
                ),
              const SizedBox(width: 20),
              _GitHubButton(scope.strings.navGitHub),
              const SizedBox(width: 8),
              toggleTheme,
            ],
          ],
        ),
      ),
    );

    // Glass blur only on desktop — mobile web keeps a solid-ish bar for
    // performance and readability.
    if (scrolled && !isMobile) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: bar,
        ),
      );
    }
    return bar;
  }
}

class _Logo extends StatelessWidget {
  final String text;
  final String subtitle;
  final VoidCallback onTap;

  const _Logo({
    required this.text,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.primary, palette.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'TS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.build(
                      context,
                      15,
                      FontWeight.w700,
                      color: palette.textPrimary,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.build(
                      context,
                      11,
                      FontWeight.w500,
                      color: palette.textMuted,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLabel extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLabel({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavLabel> createState() => _NavLabelState();
}

class _NavLabelState extends State<_NavLabel> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final active = widget.isActive;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: AppDurations.fast,
                  curve: Curves.easeOut,
                  style: AppTextStyles.build(
                    context,
                    14,
                    active || _hovered ? FontWeight.w600 : FontWeight.w500,
                    color: active
                        ? palette.primary
                        : (_hovered
                              ? palette.textPrimary
                              : palette.textSecondary),
                    height: 1.2,
                  ),
                  child: Text(widget.label),
                ),
                const SizedBox(height: 5),
                AnimatedContainer(
                  duration: AppDurations.fast,
                  curve: Curves.easeOut,
                  width: active ? 18 : (_hovered ? 8 : 0),
                  height: 2,
                  decoration: BoxDecoration(
                    color: palette.primary,
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: palette.primary.withValues(alpha: 0.6),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _Toggle({
    required this.icon,
    required this.tooltip,
    required this.onTap,
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
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Icon(icon, size: 19, color: palette.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _GitHubButton extends StatefulWidget {
  final String label;

  const _GitHubButton(this.label);

  @override
  State<_GitHubButton> createState() => _GitHubButtonState();
}

class _GitHubButtonState extends State<_GitHubButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final hovered = _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => AppLinks.open(PortfolioData.github),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, hovered ? -1.5 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: hovered ? palette.primarySoft : palette.backgroundAlt,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(
              color: hovered
                  ? palette.primary.withAlpha(110)
                  : palette.border,
            ),
            boxShadow: hovered
                ? [
                    BoxShadow(
                      color: palette.primary.withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvgIcon(
                name: 'github',
                width: 16,
                height: 16,
                color: hovered ? palette.primary : palette.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: AppTextStyles.build(
                  context,
                  13.5,
                  FontWeight.w600,
                  color: hovered ? palette.primary : palette.textSecondary,
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
