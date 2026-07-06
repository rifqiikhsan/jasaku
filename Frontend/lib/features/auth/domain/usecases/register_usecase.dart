import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/enums/user_role.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _repository;

  const RegisterUsecase(this._repository);

  Future<Either<Failure, String>> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) {
    return _repository.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );
  }
}
