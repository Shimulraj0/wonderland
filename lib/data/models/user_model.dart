class User {
  final String id;
  final String email;
  final String username;
  final String? birthDate;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.birthDate,
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? birthDate,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
