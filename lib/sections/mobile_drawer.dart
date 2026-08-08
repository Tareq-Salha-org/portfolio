import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';

/// Full-screen mobile navigation overlay with slide-in animation.
class MobileDrawer extends StatelessWidget {
  final ValueChanged<String> onNavigate;

  const MobileDrawer({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final scope = AppScope.of(context);
    final styles = AppTextStyles.of(context);

    final items = <_DrawerItem>[
      _DrawerItem(Icons.person_outline, scope.strings.navAbout, 'about'),
      _DrawerItem(Icons.code, scope.strings.navSkills, 'skills'),
      _DrawerItem(
        Icons.work_outline,
        scope.strings.navExperience,
        'experience',
      ),
      _DrawerItem(Icons.folder_outlined, scope.strings.navProjects, 'projects'),
      _DrawerItem(Icons.mail_outline, scope.strings.navContact, 'contact'),
    ];

    return Material(
      color: palette.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      PortfolioData.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.titleMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  _AppEntry(onTap: () => onNavigate('')),
                ],
              ),
              const SizedBox(height: 40),
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DrawerItemLink(
                    item: item,
                    onTap: () => onNavigate(item.key),
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: _buildAction(
                      context,
                      Icons.code,
                      'GitHub',
                      () => AppLinks.open(PortfolioData.github),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildAction(
                      context,
                      Icons.link,
                      'LinkedIn',
                      () => AppLinks.open(PortfolioData.linkedIn),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildAction(
                      context,
                      scope.isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      scope.isDark ? 'Light' : 'Dark',
                      scope.toggleTheme,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildAction(
                      context,
                      Icons.language,
                      scope.locale.label,
                      scope.toggleLocale,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final palette = AppPalette.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: palette.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.build(
                  context,
                  14,
                  FontWeight.w600,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItemLink extends StatelessWidget {
  final _DrawerItem item;
  final VoidCallback onTap;

  const _DrawerItemLink({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 20, color: palette.primary),
              const SizedBox(width: 14),
              Text(
                item.label,
                style: styles.bodyMedium.copyWith(color: palette.textPrimary),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, size: 18, color: palette.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final String key;

  const _DrawerItem(this.icon, this.label, this.key);
}

class _AppEntry extends StatelessWidget {
  final VoidCallback onTap;

  const _AppEntry({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(Icons.close, size: 24, color: palette.textSecondary),
        ),
      ),
    );
  }
}
