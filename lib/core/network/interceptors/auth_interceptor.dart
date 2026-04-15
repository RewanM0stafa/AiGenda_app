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

    print("TOKEN IN REQUEST: $token");

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;

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
      final refreshDio = Dio()..options.baseUrl = ApiEndpoints.baseUrl;

      final response = await refreshDio.put(
        ApiEndpoints.refreshToken,
        data: {'token': token, 'refreshToken': refreshToken},
      );

      final newToken = response.data['token'];
      final newRefreshToken = response.data['refreshToken'];

      if (newToken == null) return false;

      await _storage.saveAccessToken(newToken);
      await _storage.saveRefreshToken(newRefreshToken);

      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _storage.clearAll();
      }
      return false;
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
        DioException(requestOptions: request.options, error: "Session expired"),
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
