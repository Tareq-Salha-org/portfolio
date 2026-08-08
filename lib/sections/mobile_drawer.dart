import 'package:flutter/material.dart';

import '../core/animations/animations.dart';
import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../core/widgets/svg_icon.dart';

/// Full-screen mobile navigation overlay with a polished staggered entrance.
///
/// When [isOpen] becomes true the header, nav items and action buttons fade
/// and slide in sequentially with the Laravel-red accent; closing reverses the
/// sequence smoothly. The overlay itself slides in from the edge in the page.
class MobileDrawer extends StatefulWidget {
  final bool isOpen;
  final String activeSection;
  final ValueChanged<String> onNavigate;
  final VoidCallback onClose;

  const MobileDrawer({
    super.key,
    required this.isOpen,
    required this.activeSection,
    required this.onNavigate,
    required this.onClose,
  });

  @override
  State<MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<MobileDrawer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.duration(const Duration(milliseconds: 420)),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: MotionCurves.easeOutCubic,
    );
    if (!widget.isOpen) _controller.value = 0;
  }

  @override
  void didUpdateWidget(MobileDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen == oldWidget.isOpen) return;
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _slice(double start, double end) => CurvedAnimation(
    parent: _progress,
    curve: Interval(start, end, curve: MotionCurves.gentle),
  );

  Widget _item(Widget child, int index) {
    final start = (index * 0.07).clamp(0.0, 0.8);
    final anim = _slice(start, (start + 0.5).clamp(0.0, 1.0));
    if (Motion.reduceMotion) return child;
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final scope = AppScope.of(context);
    final styles = AppTextStyles.of(context);
    final active = widget.activeSection;

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
              _item(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [palette.primary, palette.accent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Center(
                              child: Text(
                                'TS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
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
                        ],
                      ),
                    ),
                    _AppEntry(onTap: widget.onClose),
                  ],
                ),
                0,
              ),
              const SizedBox(height: 36),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _item(
                            _DrawerItemLink(
                              item: items[i],
                              isActive: active == items[i].key,
                              onTap: () => widget.onNavigate(items[i].key),
                            ),
                            i + 1,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _item(
                Row(
                  children: [
                    Expanded(
                      child: _buildAction(
                        context,
                        icon: Icons.code,
                        svg: 'github',
                        label: 'GitHub',
                        onTap: () => AppLinks.open(PortfolioData.github),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildAction(
                        context,
                        icon: Icons.link,
                        label: 'LinkedIn',
                        onTap: () => AppLinks.open(PortfolioData.linkedIn),
                      ),
                    ),
                  ],
                ),
                items.length + 1,
              ),
              const SizedBox(height: 10),
              _item(
                Row(
                  children: [
                    Expanded(
                      child: _buildAction(
                        context,
                        icon: scope.isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        label: scope.isDark ? 'Light' : 'Dark',
                        onTap: scope.toggleTheme,
                      ),
                    ),
                  ],
                ),
                items.length + 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    String? svg,
    required String label,
    required VoidCallback onTap,
  }) {
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
              if (svg != null)
                AppSvgIcon(name: svg, width: 18, height: 18, color: palette.textSecondary)
              else
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
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItemLink({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: isActive ? palette.primarySoft : palette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? palette.primaryBorder : palette.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 20,
                color: isActive ? palette.primary : palette.textSecondary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: styles.bodyMedium.copyWith(
                    color: isActive ? palette.primary : palette.textPrimary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Container(
                width: isActive ? 6 : 0,
                height: 6,
                decoration: BoxDecoration(
                  color: palette.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: isActive ? palette.primary : palette.textMuted,
              ),
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
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.close, size: 22, color: palette.textSecondary),
        ),
      ),
    );
  }
}
