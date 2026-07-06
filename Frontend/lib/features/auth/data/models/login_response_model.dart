import '../../domain/entities/auth_entity.dart';

class LoginResponseModel {
  final int status;
  final LoginDataModel data;

  const LoginResponseModel({required this.status, required this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json['status'] as int,
        data: LoginDataModel.fromJson(json['data'] as Map<String, dynamic>),
      );

  AuthEntity toEntity() =>
      AuthEntity(accessToken: data.accessToken, user: data.user.toEntity());
}

class LoginDataModel {
  final String accessToken;
  final UserModel user;

  const LoginDataModel({required this.accessToken, required this.user});

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
    accessToken: json['accessToken'] as String,
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  );
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String createdAt;
  final String updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    role: json['role'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );

  UserEntity toEntity() => UserEntity(
    id: id,
    fullName: fullName,
    email: email,
    phone: phone,
    role: role,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
