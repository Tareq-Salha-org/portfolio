import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../models/models.dart';

/// Lifecycle of the portfolio JSON bootstrap.
///
/// The store starts in [loading] the moment [load] is first called (from the
/// app root, before any UI is built) and only ever moves to [loaded] or
/// [error]. The UI reacts to these transitions through [PortfolioData.status];
/// it never polls and never re-triggers the load from a widget lifecycle.
enum PortfolioDataStatus { loading, loaded, error }

/// Loads `assets/data/portfolio_data.json` exactly once at application startup
/// and exposes typed, immutable portfolio content.
///
/// Responsibilities:
///  * Idempotent — [load] is safe to call many times; the asset is fetched
///    once and reused for the whole session.
///  * Independent — loading has no relationship to locale, theme, animation
///    or user interaction. The app root calls [load] in `initState` and the
///    UI blocks behind a loading/error gate until the data is ready.
///  * Observable — [status] is a [ValueNotifier] so the root gate can react to
///    the initial loading state, the loaded state and failures (with retry).
///  * Fail-visible — load failures are logged and surfaced as [PortfolioDataStatus.error]
///    instead of silently rendering an empty site.
class PortfolioData {
  PortfolioData._();

  static Map<String, dynamic>? _raw;

  static Object? _lastError;

  /// Future for the in-flight (or already completed) load. Guards against
  /// duplicate concurrent fetches and against re-fetching on rebuilds.
  static Future<void>? _loadFuture;

  /// Reactive lifecycle used by the root gate to swap loading / error / loaded
  /// screens. Initialised to [PortfolioDataStatus.loading] so the very first
  /// frame never shows an empty portfolio.
  static ValueNotifier<PortfolioDataStatus> status =
      ValueNotifier<PortfolioDataStatus>(PortfolioDataStatus.loading);

  /// Starts (or joins) the one-time portfolio load.
  ///
  /// Passing `force: true` re-reads the asset — used only by the error
  /// screen's retry action. Ordinary callers can call [load] freely; it never
  /// reloads already-loaded data.
  static Future<void> load({bool force = false}) {
    if (!force && _loadFuture != null) return _loadFuture!;
    final future = _doLoad();
    _loadFuture = future;
    return future;
  }

  static Future<void> _doLoad() async {
    status.value = PortfolioDataStatus.loading;
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/portfolio_data.json',
      );
      _raw = json.decode(jsonStr) as Map<String, dynamic>;
      _lastError = null;
      status.value = PortfolioDataStatus.loaded;
    } catch (e, stack) {
      _raw = {};
      _lastError = e;
      // Clear the cached future so a later load() (e.g. a non-forced call)
      // naturally retries instead of returning the stale failed future.
      _loadFuture = null;
      debugPrint('Failed to load portfolio data: $e');
      debugPrintStack(stackTrace: stack);
      status.value = PortfolioDataStatus.error;
    }
  }

  /// Resets the store to its pristine, unloaded state. Intended for tests
  /// only — the app root relies on the one-time bootstrap in `main()`.
  @visibleForTesting
  static void resetForTesting() {
    _raw = null;
    _lastError = null;
    _loadFuture = null;
    status = ValueNotifier<PortfolioDataStatus>(PortfolioDataStatus.loading);
  }

  /// Human-readable summary of the last failure (for the error screen).
  static String? get lastError => _lastError?.toString();

  static Map<String, dynamic> _cv() =>
      (_raw?['cv'] as Map<String, dynamic>?) ?? const {};

  static Map<String, dynamic> _contact() =>
      (_cv()['contact'] as Map<String, dynamic>?) ?? const {};

  // --- Core identity -------------------------------------------------------

  /// Full name straight from `cv.full_name` in the JSON.
  static String get fullName =>
      _cv()['full_name'] as String? ?? 'Tareq Fareed Salha';

  static String get firstName {
    final parts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
    return parts.isNotEmpty ? parts.first : 'Tareq';
  }

  static String get lastName {
    final parts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
    return parts.length > 1 ? parts.last : 'Salha';
  }

  /// The JSON has no explicit job-title field; `Backend Developer` mirrors
  /// the opening of `cv.professional_summary` and every project role.
  static String get role => 'Backend Developer';

  static String get email => _contact()['email'] ?? 'eng.tareq.salha@gmail.com';
  static String get phone => _contact()['phone'] ?? '+963985799827';
  static String get location => _contact()['location'] ?? 'Syria';

  /// `cv.contact.github` is the source of truth for the GitHub profile.
  static String get github =>
      _contact()['github'] ?? 'https://github.com/Tareq-Salha';

  static String get githubHandle {
    final uri = Uri.tryParse(github);
    final segments = uri?.pathSegments.where((s) => s.isNotEmpty).toList();
    return (segments != null && segments.isNotEmpty)
        ? segments.last
        : 'Tareq-Salha';
  }

  static String get linkedIn =>
      _contact()['linkedin'] ?? 'https://www.linkedin.com/';
  static String? get website => _contact()['website'];

  static String get summary => _cv()['professional_summary'] ?? '';

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

  /// Spoken languages straight from `cv.languages_spoken`.
  static List<PortfolioLanguage> get languages {
    final list = (_cv()['languages_spoken'] as List<dynamic>?) ?? const [];
    return list.map((e) => PortfolioLanguage('$e')).toList();
  }

  static bool get hasCertifications {
    final certs = (_cv()['certifications'] as List<dynamic>?) ?? const [];
    return certs.isNotEmpty;
  }

  /// Total number of individual skill items across all categories — used by
  /// the About stats strip. Derived purely from the JSON.
  static int get totalSkillCount =>
      skillCategories.fold(0, (sum, c) => sum + c.skills.length);

  /// Number of distinct skill categories in the JSON.
  static int get skillCategoryCount => skillCategories.length;

  /// Number of projects in the JSON.
  static int get projectCount => projects.length;

  /// Number of professional experiences in the JSON.
  static int get experienceCount => experience.length;

  static List<String> _strList(dynamic value) =>
      value is List ? value.map((e) => '$e').toList() : const <String>[];
}

class PortfolioLanguage {
  final String name;

  const PortfolioLanguage(this.name);
}
