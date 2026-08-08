import '../core/localization/app_locale.dart';

class SkillCategory {
  final String key;
  final String title;
  final String titleAr;
  final String iconKey;
  final List<String> skills;

  const SkillCategory({
    required this.key,
    required this.title,
    required this.titleAr,
    required this.iconKey,
    required this.skills,
  });

  String localizedTitle(AppLocale locale) =>
      locale == AppLocale.ar ? titleAr : title;

  List<String> localizedSkills(AppLocale locale) => locale == AppLocale.ar
      ? skills.map((s) => _arabicSkills[s] ?? s).toList()
      : skills;

  factory SkillCategory.fromRaw(
    String key,
    String title,
    String iconKey,
    List<String> skills,
  ) {
    return SkillCategory(
      key: key,
      title: title,
      titleAr: _arabicTitles[key] ?? title,
      iconKey: iconKey,
      skills: skills,
    );
  }
}

const Map<String, String> _arabicTitles = {
  'backend_development': 'تطوير الواجهات الخلفية',
  'integrations': 'التكاملات والحلول اللحظية',
  'devops_and_tools': 'DevOps والأدوات',
  'core_competencies': 'الكفاءات الأساسية',
};

const Map<String, String> _arabicSkills = {
  'Laravel Framework': 'إطار Laravel',
  'PHP Development': 'تطوير بـ PHP',
  'RESTful APIs': 'واجهات RESTful API',
  'Database Architecture': 'معمارية قواعد البيانات',
  'Agora Voice API': 'Agora للاتصال الصوتي',
  'JoFotara (Jordanian E-invoicing)': 'JoFotara (الفوترة الإلكترونية الأردنية)',
  'Real-Time Chat & WebSockets': 'المحادثة اللحظية وWebSockets',
  'Educational Content Delivery APIs': 'واجهات توجيه المحتوى التعليمي',
  'CI/CD Pipeline Implementation': 'تنفيذ خطوط CI/CD',
  'Version Control (Git & GitHub)': 'إدارة الإصدارات (Git & GitHub)',
  'Database Optimization': 'تحسين قواعد البيانات',
  'Application Scalability': 'قابلية تطبيقية للتوسع',
  'Clean Code & API Design': 'كود نظيف وتصميم واجهات برمجية',
};
