import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../shared/enums/user_role.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final SecureStorage _storage;

  const AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final res = await _remote.login(
        LoginRequestModel(email: email, password: password, role: role),
      );

      // Simpan token & info user ke secure storage
      await _storage.saveAccessToken(res.data.accessToken);
      await _storage.saveUserRole(res.data.user.role);
      await _storage.saveUserId(res.data.user.id.toString());
      await _storage.saveFullName(res.data.user.fullName);

      return Right(res.toEntity());
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    try {
      final res = await _remote.register(
        RegisterRequestModel(
          fullName: fullName,
          email: email,
          phone: phone,
          password: password,
          role: role,
        ),
      );
      return Right(res.message);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(AppException e) => switch (e) {
    NetworkException() => NetworkFailure(e.message),
    UnauthorizedException() => UnauthorizedFailure(e.message),
    NotFoundException() => NotFoundFailure(e.message),
    ValidationException() => ValidationFailure(e.message),
    ServerException() => ServerFailure(e.message, status: e.status),
    _ => ServerFailure(e.message),
  };
}

// ── Providers ────────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(authRemoteDatasourceProvider),
    ref.read(secureStorageProvider),
  ),
);

final loginUsecaseProvider = Provider(
  (ref) => LoginUsecase(ref.read(authRepositoryProvider)),
);

final registerUsecaseProvider = Provider(
  (ref) => RegisterUsecase(ref.read(authRepositoryProvider)),
);
