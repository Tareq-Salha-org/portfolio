import 'package:flutter/material.dart';

import 'core/data/portfolio_data.dart';
import 'core/theme/theme.dart';
import 'sections/sections.dart';

/// Global keys used to resolve section positions for scroll navigation.
abstract final class SectionKeys {
  static final home = GlobalKey();
  static final about = GlobalKey();
  static final skills = GlobalKey();
  static final capabilities = GlobalKey();
  static final experience = GlobalKey();
  static final projects = GlobalKey();
  static final education = GlobalKey();
  static final contact = GlobalKey();
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scrollController = ScrollController();

  bool _menuOpen = false;
  bool _scrolled = false;
  String _activeSection = 'home';
  double _lastScrollPixels = -100;
  double _progress = 0;

  /// Scroll order used to resolve the active nav section.
  static const List<(String key, String navTarget)> _scrollOrder = [
    ('home', 'home'),
    ('about', 'about'),
    ('skills', 'skills'),
    ('capabilities', 'skills'),
    ('experience', 'experience'),
    ('projects', 'projects'),
    ('education', 'projects'),
    ('contact', 'contact'),
  ];

  Map<String, GlobalKey> get _keys => {
    'home': SectionKeys.home,
    'about': SectionKeys.about,
    'skills': SectionKeys.skills,
    'capabilities': SectionKeys.capabilities,
    'experience': SectionKeys.experience,
    'projects': SectionKeys.projects,
    'education': SectionKeys.education,
    'contact': SectionKeys.contact,
  };

  @override
  void initState() {
    super.initState();
    PortfolioData.load().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _sectionTop(String key) {
    final ctx = _keys[key]?.currentContext;
    if (ctx == null) return double.infinity;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return double.infinity;
    return box.localToGlobal(Offset.zero).dy + _scrollController.offset;
  }

  void _onScroll(double pixels) {
    var needsRebuild = false;
    final nextScrolled = pixels > 12;
    if (nextScrolled != _scrolled) {
      _scrolled = nextScrolled;
      needsRebuild = true;
    }

    final maxExtent = _scrollController.position.maxScrollExtent;
    final progress = maxExtent > 0 ? (pixels / maxExtent).clamp(0.0, 1.0) : 0.0;
    if ((progress - _progress).abs() > 0.001) {
      _progress = progress;
      needsRebuild = true;
    }

    if (needsRebuild) setState(() {});

    if ((pixels - _lastScrollPixels).abs() < 40) return;
    _lastScrollPixels = pixels;

    String? active;
    for (final (key, nav) in _scrollOrder) {
      if (_sectionTop(key) <= pixels + 160) {
        active = nav;
      } else {
        break;
      }
    }
    final resolved = active ?? 'home';
    if (resolved != _activeSection) {
      setState(() => _activeSection = resolved);
    }
  }

  void _onNavigate(String section) {
    setState(() {
      _menuOpen = false;
      if (section.isNotEmpty) _activeSection = section;
    });

    if (section.isEmpty || section == 'home') {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    final ctx = _keys[section]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.05,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        children: [
          // Main scrollable content with the real scrollbar.
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            thickness: 6,
            radius: const Radius.circular(8),
            scrollbarOrientation: ScrollbarOrientation.right,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.axis == Axis.vertical &&
                    notification.depth == 0) {
                  _onScroll(notification.metrics.pixels);
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 68),
                child: Column(
                  children: [
                    HeroSection(
                      onProjectsTap: () => _onNavigate('projects'),
                      onContactTap: () => _onNavigate('contact'),
                    ),
                    _SectionShell(
                      key: SectionKeys.about,
                      child: const AboutSection(),
                    ),
                    _SectionShell(
                      key: SectionKeys.skills,
                      child: const SkillsSection(),
                    ),
                    _SectionShell(
                      key: SectionKeys.capabilities,
                      child: const CapabilitiesSection(),
                    ),
                    _SectionShell(
                      key: SectionKeys.experience,
                      child: const ExperienceSection(),
                    ),
                    _SectionShell(
                      key: SectionKeys.projects,
                      child: const ProjectsSection(),
                    ),
                    _SectionShell(
                      key: SectionKeys.education,
                      child: const EducationSection(),
                    ),
                    _SectionShell(
                      key: SectionKeys.contact,
                      child: const ContactSection(),
                    ),
                    const FooterSection(),
                  ],
                ),
              ),
            ),
          ),
          // Fixed header overlay.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HeaderSection(
              scrolled: _scrolled,
              activeSection: _activeSection,
              onNavigate: _onNavigate,
              onMenuPressed: () => setState(() => _menuOpen = true),
            ),
          ),
          _buildScrollProgress(context),
          _buildOverlay(context),
        ],
      ),
    );
  }

  Widget _buildScrollProgress(BuildContext context) {
    final palette = AppPalette.of(context);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 3,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          alignment: FractionalOffset(0, 0),
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: _progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.primary, palette.accent],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final palette = AppPalette.of(context);
    final size = MediaQuery.sizeOf(context);
    final drawerWidth = (size.width * 0.86).clamp(300.0, 400.0).toDouble();

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !_menuOpen,
        child: AnimatedOpacity(
          opacity: _menuOpen ? 1 : 0,
          duration: const Duration(milliseconds: 220),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => setState(() => _menuOpen = false),
                child: Container(color: palette.scrim),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AnimatedSlide(
                  offset: _menuOpen ? Offset.zero : const Offset(1.2, 0),
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  child: SizedBox(
                    width: drawerWidth,
                    height: double.infinity,
                    child: Material(
                      color: palette.background,
                      child: MobileDrawer(onNavigate: _onNavigate),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  final Widget child;

  const _SectionShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
