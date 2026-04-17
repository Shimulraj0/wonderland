class ChildModel {
  final String id;
  final String name;
  final String avatarPath;
  final DateTime createdAt;

  ChildModel({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.createdAt,
  });

  ChildModel copyWith({
    String? id,
    String? name,
    String? avatarPath,
    DateTime? createdAt,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
