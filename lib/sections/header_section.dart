import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../core/widgets/widgets.dart';

/// Sticky header bar with logo, desktop nav, GitHub action and theme/locale
/// toggles. Switches to a compact bar with a menu button below desktop width.
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

    final toggleTheme = _Toggle(
      icon: scope.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      tooltip: scope.isDark ? 'Light mode' : 'Dark mode',
      onTap: scope.toggleTheme,
    );

    final toggleLocale = _Toggle(
      label: scope.locale.label,
      tooltip: 'Switch language',
      onTap: scope.toggleLocale,
    );

    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: scrolled
            ? palette.background.withValues(alpha: 0.9)
            : Colors.transparent,
        border: scrolled
            ? Border(bottom: BorderSide(color: palette.border))
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? 14 : 28),
        child: Row(
          children: [
            _Logo(
              text: PortfolioData.fullName,
              subtitle: 'Backend Developer',
              onTap: () => onNavigate('home'),
            ),
            const Spacer(),
            if (isCompact) ...[
              toggleTheme,
              const SizedBox(width: 6),
              toggleLocale,
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
              const SizedBox(width: 4),
              toggleLocale,
            ],
          ],
        ),
      ),
    );
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
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
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
          ],
        ),
      ),
    );
  }
}

class _NavLabel extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLabel({
    required this.label,
    required this.isActive,
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
        child: SizedBox(
          height: 68,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.build(
                    context,
                    14,
                    isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? palette.primary : palette.textSecondary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedContainer(
                  duration: AppDurations.fast,
                  width: isActive ? 16 : 0,
                  height: 2,
                  decoration: BoxDecoration(
                    color: palette.primary,
                    borderRadius: BorderRadius.circular(1),
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
  final IconData? icon;
  final String? label;
  final String tooltip;
  final VoidCallback onTap;

  const _Toggle({
    this.icon,
    this.label,
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
              child: icon != null
                  ? Icon(icon, size: 19, color: palette.textSecondary)
                  : Text(
                      label ?? '',
                      style: AppTextStyles.build(
                        context,
                        13.5,
                        FontWeight.w700,
                        color: palette.textSecondary,
                        height: 1.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GitHubButton extends StatelessWidget {
  final String label;

  const _GitHubButton(this.label);

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => AppLinks.open(PortfolioData.github),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: palette.backgroundAlt,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvgIcon(
                name: 'github',
                width: 16,
                height: 16,
                color: palette.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.build(
                  context,
                  13.5,
                  FontWeight.w600,
                  color: palette.textSecondary,
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
