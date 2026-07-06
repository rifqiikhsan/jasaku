import '../../../../shared/enums/user_role.dart';

class RegisterRequestModel {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final UserRole role;

  const RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'password': password,
    'role': role.toApiString(),
  };
}
