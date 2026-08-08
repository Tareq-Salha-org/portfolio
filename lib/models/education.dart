class Education {
  final String institution;
  final String degree;
  final String location;
  final String startDate;
  final String endDate;

  const Education({
    required this.institution,
    required this.degree,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromMap(Map<String, dynamic> map) => Education(
    institution: map['institution'] ?? '',
    degree: map['degree'] ?? '',
    location: map['location'] ?? '',
    startDate: map['start_date'] ?? '',
    endDate: map['end_date'] ?? '',
  );

  String get period => '$startDate - $endDate';
}
