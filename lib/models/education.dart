import '../core/localization/app_locale.dart';

class Education {
  final String institution;
  final String institutionAr;
  final String degree;
  final String degreeAr;
  final String location;
  final String startDate;
  final String endDate;

  const Education({
    required this.institution,
    required this.institutionAr,
    required this.degree,
    required this.degreeAr,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromMap(Map<String, dynamic> map) => Education(
    institution: map['institution'] ?? '',
    institutionAr:
        _institutions[map['institution']] ?? map['institution'] ?? '',
    degree: map['degree'] ?? '',
    degreeAr: _degrees[map['degree']] ?? map['degree'] ?? '',
    location: map['location'] ?? '',
    startDate: map['start_date'] ?? '',
    endDate: map['end_date'] ?? '',
  );

  String get period => '$startDate - $endDate';

  String localizedInstitution(AppLocale l) =>
      l == AppLocale.ar ? institutionAr : institution;
  String localizedDegree(AppLocale l) => l == AppLocale.ar ? degreeAr : degree;
}

const Map<String, String> _institutions = {'Damascus University': 'جامعة دمشق'};

const Map<String, String> _degrees = {
  'Software Engineering': 'هندسة البرمجيات',
};
