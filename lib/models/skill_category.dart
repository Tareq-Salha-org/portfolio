class SkillCategory {
  final String key;
  final String title;
  final String iconKey;
  final List<String> skills;

  const SkillCategory({
    required this.key,
    required this.title,
    required this.iconKey,
    required this.skills,
  });

  factory SkillCategory.fromRaw(
    String key,
    String title,
    String iconKey,
    List<String> skills,
  ) {
    return SkillCategory(
      key: key,
      title: title,
      iconKey: iconKey,
      skills: skills,
    );
  }
}
