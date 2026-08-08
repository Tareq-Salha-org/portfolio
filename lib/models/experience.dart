class Experience {
  final String role;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final List<String> responsibilities;
  final List<String> achievements;

  const Experience({
    required this.role,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.responsibilities,
    required this.achievements,
  });

  factory Experience.fromMap(Map<String, dynamic> map) {
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
    );
  }

  bool get isPresent => endDate.toLowerCase() == 'present';

  String get startFormatted => _format(startDate);
  String get endFormatted => isPresent ? 'Present' : _format(endDate);

  /// "Jan 2026 - Present" display range.
  String get dateRange => '$startFormatted - $endFormatted';

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
