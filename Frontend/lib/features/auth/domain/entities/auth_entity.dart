class AuthEntity {
  final String accessToken;
  final UserEntity user;

  const AuthEntity({required this.accessToken, required this.user});
}

class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String createdAt;
  final String updatedAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });
}
