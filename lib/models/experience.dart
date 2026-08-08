import '../core/localization/app_locale.dart';

class Experience {
  final String role;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final List<String> responsibilities;
  final List<String> responsibilitiesAr;
  final List<String> achievements;
  final List<String> achievementsAr;

  const Experience({
    required this.role,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.responsibilities,
    required this.responsibilitiesAr,
    required this.achievements,
    required this.achievementsAr,
  });

  factory Experience.fromMap(Map<String, dynamic> map) {
    final key = '${map['company']}_${map['role']}';
    final localized = ExperienceArabic.forRole(key);
    return Experience(
      role: map['role'] ?? '',
      company: map['company'] ?? '',
      location: map['location'] ?? '',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      responsibilities: List<String>.from(
        (map['responsibilities'] as List<dynamic>? ?? []).map(
          (e) => _clean('$e'),
        ),
      ),
      achievements: List<String>.from(
        (map['achievements'] as List<dynamic>? ?? []).map((e) => _clean('$e')),
      ),
      responsibilitiesAr: localized.responsibilities,
      achievementsAr: localized.achievements,
    );
  }

  bool get isPresent => endDate.toLowerCase() == 'present';

  String get startFormatted => _format(startDate);
  String get endFormatted => isPresent ? 'Present' : _format(endDate);

  /// "Jan 2026" → for display ranges" etc.
  String get dateRange => '$startFormatted - $endFormatted';

  List<String> responsibilitiesOf(AppLocale locale) =>
      locale == AppLocale.ar ? responsibilitiesAr : responsibilities;

  List<String> achievementsOf(AppLocale locale) =>
      locale == AppLocale.ar ? achievementsAr : achievements;

  static String _format(String date) {
    final parts = date.split('-');
    if (parts.length < 2) return date;
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final idx = int.tryParse(parts[1]) ?? 0;
    final month = idx > 0 && idx < months.length ? months[idx] : parts[1];
    return '$month ${parts[0]}';
  }

  static String _clean(String s) =>
      s.replaceAll(RegExp(r'\[cite:\s*\d+\]'), '').trim();
}

/// Arabic renderings of each experience entry, faithful to the English source.
class ExperienceArabic {
  ExperienceArabic._();

  static const Map<String, List<dynamic>> _store = {
    'Freelance_Freelance Backend Developer': [
      [
        'تطوير ميزات خلفية مخصصة وواجهات RESTful API لمشاريع عملاء تشمل منصات تعليمية دولية وتطبيقات ويب متخصصة.',
        'تنفيذ نماذج قواعد البيانات، وإدارة أدوار المستخدمين، ونقاط توصيل المحتوى، وتكاملات الجهات الخارجية.',
      ],
      [
        'نجاح في تقديم حلول خلفية كاملة لمنصة York التعليمية (المملكة المتحدة).',
      ],
    ],
    'GS_Field Observer': [
      [
        'إدارة العمليات اليومية وضمان سير العمل بسلاسة.',
        'التعاون مع أعضاء الفريق لتحقيق أهداف المشروع.',
      ],
      <String>[],
    ],
    'Future X_Backend Developer': [
      [
        'تطوير وصيانة تطبيقات الويب باستخدام إطار Laravel لتقديم حلول متينة وقابلة للتوسع.',
        'تعزيز نظام ERP للشركة عبر دمج Agora Voice API لتفعيل ميزات الاتصال الصوتي الفوري.',
        'تنفيذ التكامل مع نظام الفوترة الإلكترونية الأردني JoFotara لضمان الامتثال وتبسيط عمليات الفوترة.',
        'تصميم وتنفيذ خطوط CI/CD أولية لأتمتة خطوات الاختبار والنشر.',
        'تنفيذ RESTful APIs وتحسين استعلامات قواعد البيانات واستراتيجيات التخزين المؤقت.',
      ],
      [
        'دمج ناجح لـ Agora Voice API داخل نظام ERP الخاص بالشركة.',
        'دمج نظام الامتثال للفوترة الإلكترونية JoFotara.',
      ],
    ],
  };

  static ExpLocalizedSlice forRole(String key) {
    final entry = _store[key];
    if (entry == null) {
      return const ExpLocalizedSlice(responsibilities: [], achievements: []);
    }
    return ExpLocalizedSlice(
      responsibilities: (entry[0] as List).cast<String>(),
      achievements: (entry[1] as List).cast<String>(),
    );
  }
}

class ExpLocalizedSlice {
  final List<String> responsibilities;
  final List<String> achievements;

  const ExpLocalizedSlice({
    required this.responsibilities,
    required this.achievements,
  });
}
