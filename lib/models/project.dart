import '../core/localization/app_locale.dart';

/// Parsed portfolio project.
///
/// The original `portfolio_data.json` stores project descriptions and
/// contributions in Arabic, alongside English context. Both forms are kept so
/// the project can honour the bilingual design without inventing facts.
class Project {
  final String id;
  final String name;
  final String projectTypeEn;
  final String? projectTypeAr;
  final String descriptionAr;
  final String descriptionEn;
  final String primaryLanguage;
  final Map<String, double> languagesBreakdown;
  final List<String> techStack;
  final String roleEn;
  final String roleAr;
  final List<String> contributionsAr;
  final List<String> contributionsEn;
  final String? demoUrl;
  final bool isArchived;

  const Project({
    required this.id,
    required this.name,
    required this.projectTypeEn,
    this.projectTypeAr,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.primaryLanguage,
    required this.languagesBreakdown,
    required this.techStack,
    required this.roleEn,
    required this.roleAr,
    required this.contributionsAr,
    required this.contributionsEn,
    this.demoUrl,
    this.isArchived = false,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    final source = English.slice('${map['id'] ?? ''}');
    return Project(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      projectTypeEn: map['project_type'] ?? '',
      projectTypeAr: ARN.projectType(map['project_type'] ?? ''),
      descriptionAr: _clean(map['description'] ?? ''),
      descriptionEn: source.description,
      primaryLanguage: map['primary_language'] ?? 'PHP',
      languagesBreakdown:
          (map['languages_breakdown'] as Map<String, dynamic>? ?? {}).map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ),
      techStack: List<String>.from(map['tech_stack'] ?? []),
      roleEn: source.role,
      roleAr: _clean(map['role_responsibility'] ?? ''),
      contributionsEn: source.contributions,
      contributionsAr: List<String>.from(
        (map['notable_contributions'] as List<dynamic>? ?? []).map(
          (e) => _clean('$e'),
        ),
      ),
      demoUrl: map['demo_url'],
      isArchived: map['is_archived'] ?? false,
    );
  }

  String localizedType(AppLocale locale) =>
      locale == AppLocale.ar && (projectTypeAr?.isNotEmpty ?? false)
      ? projectTypeAr!
      : projectTypeEn;

  String localizedDescription(AppLocale locale) =>
      locale == AppLocale.ar ? descriptionAr : descriptionEn;

  String localizedRole(AppLocale locale) =>
      locale == AppLocale.ar ? roleAr : roleEn;

  List<String> localizedContributions(AppLocale locale) =>
      locale == AppLocale.ar ? contributionsAr : contributionsEn;

  /// Top technology badges for visual composition.
  List<String> get heroTech => techStack.take(3).toList();

  static String _clean(String s) =>
      s.replaceAll(RegExp(r'\[cite:\s*\d+\]'), '').trim();
}

/// Faithful English translations of the four project descriptions, so the
/// English site does not mix languages. These are translations — the factual
/// Arabic source remains the canonical description.
class English {
  English._();

  static const Map<String, List<dynamic>> _store = {
    'york-educational-platform': [
      'Freelance project building the backend and APIs of the British York educational platform. It manages courses, students, teachers and assessments, with content quality management.',
      'Freelance Backend Developer - designing and developing the database and APIs behind course, assessment and user-account management.',
      [
        'Built a robust backend architecture guaranteeing smooth, fast delivery of lessons and educational content.',
        'Implemented dedicated permissions for students, teachers and the administration.',
      ],
    ],
    'litaskunu-app': [
      'A social and matchmaking platform aligned with Islamic guidelines that enables disciplined and safe introductions, with a real-time chat engine and role and permission management.',
      'Backend Developer - developed the RESTful APIs, the real-time chat logic and user permission and access controls.',
      [
        'Built a secure API architecture for the chat and direct-communication system.',
        'Applied access and permission controls according to Islamic principles and the defined roles.',
      ],
    ],
    'rahti-app': [
      'An integrated on-demand booking system for home services (cleaning, maintenance and other services), for showing services and managing orders, bookings and providers.',
      'Backend Developer - designed the database and booking rules, and developed the APIs that manage providers and orders.',
      [
        'Developed a flexible booking system connecting the customer with the services office and the service provider.',
        'Optimised the underlying database queries to keep order processing fast and easily scalable.',
      ],
    ],
    'futurex-erp-integration': [
      'An ERP enhancement project integrating the Agora Voice API for real-time voice and the Jordanian JoFotara e-invoicing system.',
      'Backend Developer - built the integrations with external services, e-invoicing and automation.',
      [
        'Integrated Agora Voice API for direct real-time voice communication inside the system.',
        'Connected the JoFotara e-invoicing system to guarantee legal compliance.',
      ],
    ],
  };

  static EnglishSlice slice(String id) {
    final entry = _store[id];
    if (entry == null) {
      return const EnglishSlice(description: '', role: '', contributions: []);
    }
    return EnglishSlice(
      description: entry[0] as String,
      role: entry[1] as String,
      contributions: (entry[2] as List).cast<String>(),
    );
  }
}

class EnglishSlice {
  final String description;
  final String role;
  final List<String> contributions;

  const EnglishSlice({
    required this.description,
    required this.role,
    required this.contributions,
  });
}

/// Arabic labels for project types.
class ARN {
  ARN._();

  static String? projectType(String type) {
    const map = <String, String>{
      'Freelance / Educational Platform Backend':
          'فريلانس / خلفية منصة تعليمية',
      'Social & Matchmaking Platform Backend': 'خلفية منصة تواصل وتوافق',
      'On-Demand Home Services Booking System':
          'نظام حجز خدمات منزلية عند الطلب',
      'ERP System Enhancement & E-Invoicing':
          'تطوير نظام ERP والفوترة الإلكترونية',
    };
    return map[type];
  }
}
