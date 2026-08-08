import 'package:flutter/material.dart';

import 'core/theme/theme.dart';
import 'core/widgets/widgets.dart';
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
  final _progress = ValueNotifier<double>(0);

  bool _menuOpen = false;
  bool _scrolled = false;
  String _activeSection = 'home';
  double _lastScrollPixels = -100;

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

  // Note: portfolio data is loaded once at the app root (see main.dart);
  // this page only renders once that data is ready (see PortfolioGate).

  @override
  void dispose() {
    _scrollController.dispose();
    _progress.dispose();
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
    final nextScrolled = pixels > 12;
    if (nextScrolled != _scrolled) {
      setState(() => _scrolled = nextScrolled);
    }

    final maxExtent = _scrollController.position.maxScrollExtent;
    _progress.value = maxExtent > 0
        ? (pixels / maxExtent).clamp(0.0, 1.0)
        : 0.0;

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
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        children: [
          // Ambient technical network behind everything.
          Positioned(
            top: -AnimatedBackground.parallaxPad,
            left: 0,
            right: 0,
            height: size.height + AnimatedBackground.parallaxPad * 2,
            child: AnimatedBackground(scrollController: _scrollController),
          ),
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
                      scrollController: _scrollController,
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
          // Scroll progress line.
          ScrollProgressBar(progress: _progress),
          _buildOverlay(context),
        ],
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
          curve: Curves.easeOut,
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
                      child: MobileDrawer(
                        isOpen: _menuOpen,
                        activeSection: _activeSection,
                        onNavigate: _onNavigate,
                        onClose: () => setState(() => _menuOpen = false),
                      ),
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
