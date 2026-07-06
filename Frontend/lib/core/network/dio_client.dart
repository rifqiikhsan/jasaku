import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import '../utils/logger.dart';

class DioClient {
  DioClient._();

  static Dio create(Ref ref) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(ref),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => logger.d(o),
      ),
    ]);

    return dio;
  }
}

final dioProvider = Provider<Dio>((ref) => DioClient.create(ref));
