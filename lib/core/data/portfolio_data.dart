import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../localization/app_locale.dart';
import '../../models/models.dart';

/// Loads `assets/data/portfolio_data.json` once and exposes typed, immutable
/// portfolio content. This is the only place that touches the raw JSON.
class PortfolioData {
  PortfolioData._();

  static Map<String, dynamic>? _raw;

  static Future<void> load() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/portfolio_data.json',
      );
      _raw = json.decode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Failed to load portfolio data: $e');
      _raw = {};
    }
  }

  static Map<String, dynamic> _cv() =>
      (_raw?['cv'] as Map<String, dynamic>?) ?? const {};

  static Map<String, dynamic> _contact() =>
      (_cv()['contact'] as Map<String, dynamic>?) ?? const {};

  // --- Core identity -------------------------------------------------------

  static String get fullName => 'Tareq Fareed Salha';
  static String get firstName => 'Tareq';
  static String get lastName => 'Salha';
  static String get role => 'Backend Developer';
  static String get email => _contact()['email'] ?? 'eng.tareq.salha@gmail.com';
  static String get phone => _contact()['phone'] ?? '+963985799827';
  static String get location => _contact()['location'] ?? 'Syria';

  /// The notes section of the JSON explicitly replaces the older GitHub URL
  /// with https://github.com/TarekSalha288. This supersedes the `cv.contact`
  /// value.
  static String get github => 'https://github.com/TarekSalha288';
  static String get githubHandle => 'TarekSalha288';

  static String get linkedIn =>
      _contact()['linkedin'] ?? 'https://www.linkedin.com/';
  static String? get website => _contact()['website'];

  static String get summary => _cv()['professional_summary'] ?? '';

  static String get summaryAr =>
      'مطوّر خلفي (Backend) مدفوع بالنتائج، يتمتّع بخبرة في إطار عمل Laravel مع القدرة على بناء تطبيقات ويب متينة تخدم أهداف الأعمال.'
      ' خبرة مثبتة في تنفيذ RESTful APIs، وتحسين أداء قواعد البيانات، وتعزيز قابلية التوسع. خبرة عملية في الميزات اللحظية،'
      ' المنصات التعليمية، أسواق الخدمات، تكاملات الأنظمة، وأتمتة البنية التحتية.';

  // --- Typed collections ----------------------------------------------------

  static List<Experience> get experience {
    final list = (_cv()['experience'] as List<dynamic>?) ?? const [];
    return list
        .map((e) => Experience.fromMap((e as Map).cast<String, dynamic>()))
        .toList();
  }

  static List<Project> get projects {
    final list = (_raw?['projects'] as List<dynamic>?) ?? const [];
    return list
        .map((e) => Project.fromMap((e as Map).cast<String, dynamic>()))
        .toList();
  }

  static List<Education> get education {
    final list = (_cv()['education'] as List<dynamic>?) ?? const [];
    return list
        .map((e) => Education.fromMap((e as Map).cast<String, dynamic>()))
        .toList();
  }

  static List<SkillCategory> get skillCategories {
    final skills = (_cv()['skills'] as Map<String, dynamic>?) ?? const {};
    return [
      SkillCategory.fromRaw(
        'backend_development',
        'Backend Development',
        'backend',
        _strList(skills['backend_development']),
      ),
      SkillCategory.fromRaw(
        'integrations',
        'Integrations & Real-Time',
        'integrations',
        _strList(skills['integrations']),
      ),
      SkillCategory.fromRaw(
        'devops_and_tools',
        'DevOps & Tools',
        'devops',
        _strList(skills['devops_and_tools']),
      ),
      SkillCategory.fromRaw(
        'core_competencies',
        'Core Competencies',
        'core',
        _strList(skills['core_competencies']),
      ),
    ];
  }

  static List<PortfolioLanguage> get languages => const [
    PortfolioLanguage('Arabic', 'العربية'),
    PortfolioLanguage('English', 'الإنجليزية'),
  ];

  static bool get hasCertifications {
    final certs = (_cv()['certifications'] as List<dynamic>?) ?? const [];
    return certs.isNotEmpty;
  }

  static String summaryOf(AppLocale locale) =>
      locale == AppLocale.ar ? summaryAr : summary;

  static List<String> _strList(dynamic value) =>
      value is List ? value.map((e) => '$e').toList() : const <String>[];
}

class PortfolioLanguage {
  final String name;
  final String nameAr;

  const PortfolioLanguage(this.name, this.nameAr);

  String localized(AppLocale locale) => locale == AppLocale.ar ? nameAr : name;
}
