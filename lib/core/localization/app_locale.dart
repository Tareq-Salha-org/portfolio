import 'package:flutter/material.dart';

enum AppLocale {
  en(code: 'en', label: 'EN', direction: TextDirection.ltr, native: 'English'),
  ar(code: 'ar', label: 'ع', direction: TextDirection.rtl, native: 'العربية');

  const AppLocale({
    required this.code,
    required this.label,
    required this.direction,
    required this.native,
  });

  final String code;
  final String label;
  final TextDirection direction;
  final String native;
}

/// Lightweight localization for the portfolio UI.
///
/// The source data in `portfolio_data.json` is bilingual, so the project
/// ships with both English and Arabic chrome and full RTL support.
class AppStrings {
  static AppStrings of(AppLocale locale) => locale == AppLocale.ar ? _ar : _en;

  static const _en = AppStrings._pick();

  static const _ar = AppStrings._pick(ar: true);

  final bool ar;
  const AppStrings._pick({this.ar = false});

  String _t(String en, String arText) => ar ? arText : en;

  // Navigation
  String get navHome => _t('Home', 'الرئيسية');
  String get navAbout => _t('About', 'من أنا');
  String get navSkills => _t('Skills', 'المهارات');
  String get navExperience => _t('Experience', 'الخبرات');
  String get navProjects => _t('Projects', 'المشاريع');
  String get navContact => _t('Contact', 'تواصل');
  String get navGitHub => _t('GitHub', 'جيت‌هب');

  // Hero
  String get heroRole => _t('Backend Developer', 'مطوّر Backend');
  String get heroLocation => _t('Syria', 'سوريا');
  String get heroHeadline1 =>
      _t('Scalable backend systems,', 'أنظمة خلفية قابلة للتوسع،');
  String get heroHeadline2 => _t(
    'clean APIs and real integrations.',
    'واجهات برمجية نظيفة وتكاملات حقيقية.',
  );
  String get heroIntro => _t(
    'I build reliable, high-performance server-side applications with Laravel, PHP and MySQL — from RESTful APIs to real-time systems and third-party integrations.',
    'أبني تطبيقات خلفية موثوقة وعالية الأداء باستخدام Laravel و PHP و MySQL — من واجهات RESTful API إلى الأنظمة اللحظية وتكاملات الجهات الخارجية.',
  );
  String get heroCtaProjects => _t('View Projects', 'استعرض المشاريع');
  String get heroCtaContact => _t('Get In Touch', 'تواصل معي');
  String get heroScroll => _t('Scroll to explore', 'مرّر للاستكشاف');

  // Hero terminal
  String get termWho => _t('whoami', 'whoami');
  String get termIdentity => _t('backend-engineer', 'backend-engineer');
  String get termStack => _t('stack', 'stack');
  String get termStackValue => _t(
    'Laravel • PHP • MySQL • REST API',
    'Laravel • PHP • MySQL • REST API',
  );
  String get termFocus => _t('focus', 'focus');
  String get termFocusValue => _t(
    'Scalability • APIs • Integrations',
    'Scalability • APIs • Integrations',
  );
  String get termStatus => _t('● 200 OK', '● 200 OK');

  // Section headers
  String get eyebrowAbout => _t('PROFILE', 'نبذة');
  String get aboutTitle =>
      _t('Backend Engineer with a product mindset', 'مطوّر خلفي بعقلية المنتج');
  String get aboutSubtitle => _t(
    'How I approach software engineering and what I focus on.',
    'كيف أتعامل مع هندسة البرمجيات وما هي أولوياتي.',
  );

  String get eyebrowSkills => _t('SKILLS', 'المهارات');
  String get skillsTitle =>
      _t('Skills & Technology Stack', 'المهارات والتقنيات');
  String get skillsSubtitle => _t(
    'The technologies and practices I use to ship robust backend systems.',
    'التقنيات والممارسات التي أستخدمها لبناء أنظمة خلفية متينة.',
  );

  String get eyebrowExperience => _t('EXPERIENCE', 'الخبرات');
  String get experienceTitle => _t('Professional Experience', 'الخبرة المهنية');
  String get experienceSubtitle => _t(
    'My journey building real products in production.',
    'رحلتي في بناء منتجات حقيقية في بيئة الإنتاج.',
  );

  String get eyebrowProjects => _t('PROJECTS', 'المشاريع');
  String get projectsTitle => _t('Featured Projects', 'مشاريع مختارة');
  String get projectsSubtitle => _t(
    'Backend systems I designed, built and shipped.',
    'أنظمة خلفية صمّمتها وبنيتها وأطلقها.',
  );

  String get eyebrowCapabilities => _t('CAPABILITIES', 'القدرات');
  String get capabilitiesTitle =>
      _t('Engineering Capabilities', 'القدرات الهندسية');
  String get capabilitiesSubtitle => _t(
    'Core strengths I bring to every codebase.',
    'نقاط القوة الأساسية التي أضيفها لكل قاعدة برمجية.',
  );

  String get eyebrowEducation => _t('EDUCATION', 'التعليم');
  String get educationTitle => _t('Education', 'التعليم');
  String get languagesTitle => _t('Languages', 'اللغات');

  String get eyebrowContact => _t('CONTACT', 'تواصل');
  String get contactTitle =>
      _t("Let's build something reliable", 'لنبنِ شيئًا موثوقًا');
  String get contactSubtitle => _t(
    'Have a backend project in mind? I\'m available for freelance and full-time opportunities.',
    'لديك مشروع خلفي في بالك؟ أنا متاح لفرص العمل الحر والوظائف بدوام كامل.',
  );

  String get footerRights => _t('Tareq Salha', 'طارق صالحة');
  String get footerTagline => _t('Backend Developer', 'مطوّر Backend');
  String get footerBuilt => _t(
    '© 2026 Tareq Salha · Built with Flutter',
    '© 2026 طارق صالحة · مبني بـ Flutter',
  );

  // Project details dialog
  String get dialogClose => _t('Close', 'إغلاق');
  String get dialogRole => _t('My role', 'الدور في المشروع');
  String get dialogContributions => _t('Key contributions', 'أبرز المساهمات');
  String get dialogTech => _t('Technology stack', 'التقنيات');
  String get dialogLanguages => _t('Languages', 'اللغات');
  String get cardDetails => _t('View details', 'عرض التفاصيل');
  String get cardRole => _t('Role', 'الدور');
  String get cardContributions => _t('Contributions', 'المساهمات');
  String get keyAchievements => _t('Key achievements', 'أبرز الإنجازات');
}
