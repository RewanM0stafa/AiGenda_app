// ( Engine = DioConsumer )
// هنا بنجهز الـ Dio وبنضيف له الـ Interceptors (المفتشين) اللي بيشوفوا التوكن.

// 4. المفتشين (Interceptors)
// ده بيطبع لك كل حاجة بتحصل في الـ Console عشان تشوفي الـ API رايح فين وجاي منين



import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    // 1. BaseUrl
    dio.options.baseUrl = ApiEndpoints.baseUrl;

    // 2. Waiting & TimeOut
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // 4. المفتشين (Interceptors)
    // ده هيطبعلي كل حاجة بتحصل في الـ Console عشان أشوف الـ API رايح فين وجاي منين
    dio.interceptors.addAll([
      AuthInterceptor(dio),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: false,
      ),
    ]);
  }
}
