import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegisterResponseModel> register(RegisterRequestModel request);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;

  const AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final res = await _dio.post(ApiEndpoints.login, data: request.toJson());
      return LoginResponseModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );
      return RegisterResponseModel.fromJson(res.data as Map<String, dynamic>);
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

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasourceImpl(ref.read(dioProvider)),
);
