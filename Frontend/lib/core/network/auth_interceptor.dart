import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  // ── Request: inject token ────────────────────────────────
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  // ── Response error: handle 401 ───────────────────────────
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefreshToken(err.requestOptions);

      if (refreshed != null) {
        // Retry request dengan token baru
        handler.resolve(refreshed);
        return;
      }

      // Refresh gagal — paksa logout
      await _ref.read(secureStorageProvider).clearTokens();
      // TODO: redirect ke login via router
    }

    handler.next(err);
  }

  // ── Refresh token ────────────────────────────────────────
  Future<Response?> _tryRefreshToken(RequestOptions original) async {
    try {
      final storage = _ref.read(secureStorageProvider);
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken == null) return null;

      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
      final res = await dio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = res.data['access_token'] as String;
      final newRefreshToken = res.data['refresh_token'] as String?;

      await storage.saveAccessToken(newAccessToken);
      if (newRefreshToken != null) {
        await storage.saveRefreshToken(newRefreshToken);
      }

      // Retry original request dengan token baru
      original.headers['Authorization'] = 'Bearer $newAccessToken';
      return await dio.fetch(original);
    } catch (_) {
      return null;
    }
  }
}
