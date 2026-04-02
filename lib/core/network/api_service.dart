// api_service.dart
// Fix: validateStatus عشان نقدر نقرأ الـ response body من السيرفر

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<dynamic> post(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.post(path,
        data: data,
        queryParameters: queryParameters,
        options: Options(validateStatus: (s) => true));
    _checkStatus(response);
    return response.data;
  }

  

  Future<dynamic> put(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.put(path,
        data: data,
        queryParameters: queryParameters,
        options: Options(validateStatus: (s) => true));
    _checkStatus(response);
    return response.data;
  }

  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(path,
        queryParameters: queryParameters,
        options: Options(validateStatus: (s) => true));
    _checkStatus(response);
    return response.data;
  }

  Future<dynamic> delete(String path) async {
    final response = await _dio.delete(path,
        options: Options(validateStatus: (s) => true));
    _checkStatus(response);
    return response.data;
  }

  // بنرمي exception يحمل الـ response data عشان _handleError تقدر تقراه
  void _checkStatus(Response response) {
    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}