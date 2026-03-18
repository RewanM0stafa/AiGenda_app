import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';
import '../api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService _storage = SecureStorageService();

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final token = await _storage.getToken();
      final refreshToken = await _storage.getRefreshToken();

      if (token != null && refreshToken != null) {
        try {
          final response = await dio.put(
            ApiEndpoints.refreshToken,
            data: {'token': token, 'refreshToken': refreshToken},
          );

          final newToken = response.data['token'];
          final newRefreshToken = response.data['refreshToken'];

          await _storage.saveToken(newToken);
          await _storage.saveRefreshToken(newRefreshToken);

          // أعد الـ request الأصلي بالتوكن الجديد
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await dio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        } catch (_) {
          await _storage.clearAll();
        }
      }
    }
    handler.next(err);
  }
}