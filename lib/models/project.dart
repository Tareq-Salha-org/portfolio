/// Parsed portfolio project.
///
/// This is an English-only site. Project descriptions, roles and
/// contributions come from [English], which holds the canonical English
/// content for each project id.
class Project {
  final String id;
  final String name;
  final String projectType;
  final String description;
  final String primaryLanguage;
  final Map<String, double> languagesBreakdown;
  final List<String> techStack;
  final String role;
  final List<String> contributions;
  final String? demoUrl;
  final String? thumbnail;
  final bool isArchived;

  const Project({
    required this.id,
    required this.name,
    required this.projectType,
    required this.description,
    required this.primaryLanguage,
    required this.languagesBreakdown,
    required this.techStack,
    required this.role,
    required this.contributions,
    this.demoUrl,
    this.thumbnail,
    this.isArchived = false,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    final source = English.slice('${map['id'] ?? ''}');
    return Project(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      projectType: map['project_type'] ?? '',
      description: source.description,
      primaryLanguage: map['primary_language'] ?? 'PHP',
      languagesBreakdown:
          (map['languages_breakdown'] as Map<String, dynamic>? ?? {}).map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ),
      techStack: List<String>.from(map['tech_stack'] ?? []),
      role: source.role,
      contributions: source.contributions,
      demoUrl: map['demo_url'],
      thumbnail: map['thumbnail'],
      isArchived: map['is_archived'] ?? false,
    );
  }

  /// Top technology badges for visual composition.
  List<String> get heroTech => techStack.take(3).toList();
}

/// Canonical English content for each project (description, role and key
/// contributions), keyed by project id. `portfolio_data.json` is English-only,
/// and its project entries carry just the metadata; this class supplies the
/// richer prose shown on cards and in the details dialog.
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
