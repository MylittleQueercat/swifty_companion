class UserModel {
  final String login;
  final String? email;
  final String? phone;
  final String displayName;
  final String? imageUrl;
  final int level;
  final String? location;
  final int wallet;
  final int correctionPoints;
  final List<SkillModel> skills;
  final List<ProjectModel> projects;

  UserModel({
    required this.login,
    this.email,
    this.phone,
    required this.displayName,
    this.imageUrl,
    required this.level,
    this.location,
    required this.wallet,
    required this.correctionPoints,
    required this.skills,
    required this.projects,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Cursus users list — pick the first cursus (or main one) for level/skills
    final cursusUsers = json['cursus_users'] as List<dynamic>? ?? [];
    final mainCursus = cursusUsers.isNotEmpty ? cursusUsers.last : null;

    final skillsJson = mainCursus?['skills'] as List<dynamic>? ?? [];
    final skills = skillsJson
        .map((s) => SkillModel.fromJson(s as Map<String, dynamic>))
        .toList();

    final projectsJson = json['projects_users'] as List<dynamic>? ?? [];
    final projects = projectsJson
        .map((p) => ProjectModel.fromJson(p as Map<String, dynamic>))
        .toList();

    return UserModel(
      login: json['login'] ?? '',
      email: json['email'],
      phone: json['phone'],
      displayName: json['displayname'] ?? json['login'] ?? '',
      imageUrl: json['image']?['link'],
      level: (mainCursus?['level'] as num?)?.round() ?? 0,
      location: json['location'],
      wallet: json['wallet'] ?? 0,
      correctionPoints: json['correction_point'] ?? 0,
      skills: skills,
      projects: projects,
    );
  }
}

class SkillModel {
  final String name;
  final double level;

  SkillModel({required this.name, required this.level});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] ?? '',
      level: (json['level'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ProjectModel {
  final String name;
  final String status;
  final int? finalMark;
  final bool validated;

  ProjectModel({
    required this.name,
    required this.status,
    this.finalMark,
    required this.validated,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json['project']?['name'] ?? '',
      status: json['status'] ?? '',
      finalMark: json['final_mark'],
      validated: json['validated?'] == true,
    );
  }
}
