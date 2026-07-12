import 'package:fpdart/fpdart.dart';
import 'package:jasaku/features/home/domain/entities/service_entity.dart';
import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategory();
  Future<Either<Failure, List<ServiceEntity>>> getServices();
}
