import 'package:fpdart/fpdart.dart';
import 'package:jasaku/features/home/domain/entities/service_entity.dart';
import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/home_repository.dart';

class HomeUsecase {
  final HomeRepository _repository;

  const HomeUsecase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> getCategory() {
    return _repository.getCategory();
  }

  Future<Either<Failure, List<ServiceEntity>>> getServices() {
    return _repository.getServices();
  }
}
