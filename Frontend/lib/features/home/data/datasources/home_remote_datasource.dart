import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jasaku/features/home/data/models/service_model.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/category_model.dart';

abstract class HomeRemoteDatasource {
  Future<List<CategoryModel>> getCategory();
  Future<List<ServiceModel>> getServices();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final Dio _dio;

  const HomeRemoteDatasourceImpl(this._dio);

  @override
  Future<List<CategoryModel>> getCategory() async {
    try {
      final res = await _dio.get(ApiEndpoints.categories);
      final json = res.data as Map<String, dynamic>;
      final list = json['data'] as List;

      return list
          .map((e) => CategoryModel.fromJson(e as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final res = await _dio.get(ApiEndpoints.services);
      final json = res.data as Map<String, dynamic>;
      final list = json['data'] as List;

      return list
          .map((e) => ServiceModel.fromJson(e as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Never _handleDioError(DioException e) {
    final data = e.response?.data as Map<String, dynamic>?;
    final raw = data?['message'];
    final message = switch (raw) {
      String s => s,
      List l => l.first.toString(),
      _ => 'Terjadi kesalahan',
    };
    final status = e.response?.statusCode;

    switch (status) {
      case 400:
        throw ValidationException(message: message, status: status);
      case 401:
        throw UnauthorizedException(message: message);
      case 404:
        throw NotFoundException(message: message);
      default:
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        throw ServerException(message: message, status: status);
    }
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>(
  (ref) => HomeRemoteDatasourceImpl(ref.read(dioProvider)),
);
