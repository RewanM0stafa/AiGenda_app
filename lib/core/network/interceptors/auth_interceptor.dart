import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';
import '../api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService _storage = SecureStorageService();

  bool _isRefreshing = false;
  final List<_PendingRequest> _queue = [];

  AuthInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await _storage.getAccessToken();

    // ✅ Debug مهم
    print("TOKEN IN REQUEST: $token");

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;

    // ⛔️ منع loop
    if (err.requestOptions.path.contains(ApiEndpoints.refreshToken)) {
      return handler.next(err);
    }

    if (is401) {
      _queue.add(_PendingRequest(err.requestOptions, handler));

      if (!_isRefreshing) {
        _isRefreshing = true;

        final success = await _refreshToken();

        if (success) {
          await _retryQueuedRequests();
        } else {
          await _failQueuedRequests();
          await _storage.clearAll();
        }

        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    final token = await _storage.getAccessToken();
    final refreshToken = await _storage.getRefreshToken();

    if (token == null || refreshToken == null) return false;

    try {
      final refreshDio = Dio()
        ..options.baseUrl = ApiEndpoints.baseUrl;

      final response = await refreshDio.put(
        ApiEndpoints.refreshToken,
        data: {
          'token': token,
          'refreshToken': refreshToken,
        },
      );

      final newToken = response.data['token'];
      final newRefreshToken = response.data['refreshToken'];

      await _storage.saveAccessToken(newToken);
      await _storage.saveRefreshToken(newRefreshToken);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _retryQueuedRequests() async {
    for (final request in _queue) {
      final token = await _storage.getAccessToken();

      request.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.request(
        request.options.path,
        data: request.options.data,
        queryParameters: request.options.queryParameters,
        options: Options(
          method: request.options.method,
          headers: request.options.headers,
        ),
      );

      request.handler.resolve(response);
    }

    _queue.clear();
  }

  Future<void> _failQueuedRequests() async {
    for (final request in _queue) {
      request.handler.reject(
        DioException(
          requestOptions: request.options,
          error: "Session expired",
        ),
      );
    }

    _queue.clear();
  }
}

class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _PendingRequest(this.options, this.handler);
}

/*

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService _storage = SecureStorageService();

  bool _isRefreshing = false;

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
    final isUnauthorized = err.response?.statusCode == 401;

    final hasAuthHeader =
        err.requestOptions.headers['Authorization'] != null;

    if (isUnauthorized && hasAuthHeader && !_isRefreshing) {
      _isRefreshing = true;

      final token = await _storage.getToken();
      final refreshToken = await _storage.getRefreshToken();

      if (token != null && refreshToken != null) {
        try {
          /// ✅ Dio منفصل للـ refresh
          final refreshDio = Dio()
            ..options.baseUrl = ApiEndpoints.baseUrl;

          final response = await refreshDio.put(
            ApiEndpoints.refreshToken,
            data: {
              'token': token,
              'refreshToken': refreshToken,
            },
          );

          final newToken = response.data['token'];
          final newRefreshToken = response.data['refreshToken'];

          await _storage.saveToken(newToken);
          await _storage.saveRefreshToken(newRefreshToken);

          /// ✅ إعادة الطلب الأصلي
          final options = err.requestOptions;

          options.headers['Authorization'] = 'Bearer $newToken';

          final retryResponse = await dio.request(
            options.path,
            data: options.data,
            queryParameters: options.queryParameters,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
          );

          _isRefreshing = false;
          return handler.resolve(retryResponse);
        } catch (e) {
          _isRefreshing = false;
          await _storage.clearAll();
        }
      }
    }

    handler.next(err);
  }
}



 */
/*
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
*/