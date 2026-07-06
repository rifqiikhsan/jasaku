import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/enums/user_role.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
    required UserRole role,
  });

  Future<Either<Failure, String>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  });
}
