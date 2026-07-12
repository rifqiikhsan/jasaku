import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jasaku/features/home/domain/entities/service_entity.dart';
import 'package:jasaku/features/home/domain/usecases/home_use_case.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource _remote;

  const HomeRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategory() async {
    try {
      final res = await _remote.getCategory();
      return Right(res.map((e) => e.toEntity()).toList());
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices() async {
    try {
      final res = await _remote.getServices();
      return Right(res.map((e) => e.toEntity()).toList());
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

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.read(homeRemoteDatasourceProvider)),
);

final homeUsecaseProvider = Provider(
  (ref) => HomeUsecase(ref.read(homeRepositoryProvider)),
);
