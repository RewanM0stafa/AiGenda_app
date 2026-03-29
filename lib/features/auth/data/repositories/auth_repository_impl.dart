//  أنا خلاص عملت الميثودز اللي هتبقى ترجمان الداتا
// الريبو دا مسؤول عن إني أستدعيهم وأطبقهم ع الداتا
// مازال بيشتغل بس ع الداتا لسه


import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login/login_request_model.dart';
import '../models/login/login_response_model.dart';
import '../models/password/forget_password_request_model.dart';
import '../models/password/reset_password_request_model.dart';
import '../models/register/confirm_email_request_model.dart';
import '../models/register/register_request_model.dart';
import '../models/register/resend_confirm_email_request_model.dart';
import '../models/token/refresh_token_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final SecureStorageService storage;

  AuthRepositoryImpl({
    required this.apiService,
    required this.storage,
  });
  String _handleError(dynamic error) {
    if (error is DioException) {
      // 1. لو السيرفر رد فعلاً (حتى لو الرد فيه خطأ)
      if (error.response != null) {
        final data = error.response?.data;

        if (data is Map<String, dynamic>) {
          final problemDetails = data['problemDetails'];

          // أ. معالجة الـ problemDetails (النمط اللي إنتِ متبعاه)
          if (problemDetails is Map<String, dynamic>) {
            final errors = problemDetails['error'];

            if (errors is List && errors.isNotEmpty) {
              // تعديل ذكي: لو فيه خطأ واحد هاته، لو أكتر هات التاني (حسب نظام الباك عندك)
              return errors.length >= 2 ? errors[1].toString() : errors[0].toString();
            }
            return problemDetails['title'] ?? 'Server error occurred';
          }

          // ب. لو الباك-إند باعت رسالة مباشرة (زي message أو error)
          return data['message']?.toString() ?? data['error']?.toString() ?? 'Something went wrong';
        }

        // ج. لو مفيش Body أصلاً بس فيه Status Code (زي 500 أو 404)
        if (error.response?.statusCode == 500) return 'Internal Server Error (500)';
        if (error.response?.statusCode == 404) return 'Service not found (404)';
      }

      // 2. أخطاء الـ Timeout (الشبكة بطيئة)
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Connection timeout. Please check your internet.';
      }

      // 3. لو مفيش إنترنت خالص (No Internet Connection)
      if (error.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please connect and try again.';
      }

      return 'Network error: ${error.type.name}';
    }

    // 4. لو حصل Bug في الكود نفسه (Null pointer مثلاً)
    return 'Unexpected error. Please try again.';
  }
  // ── Login ──
  @override
  Future<Either<String, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      /// backend ممكن يرجع error جوه 200
      if (response is Map<String, dynamic> &&
          response['problemDetails'] != null) {
        return Left(_handleError(DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: response,
          ),
        )));
      }

      /// تأمين parsing
      if (response is! Map<String, dynamic>) {
        return const Left('Invalid server response');
      }

      final loginResponse = LoginResponse.fromJson(response);

      /// حفظ البيانات
      await Future.wait([
        //storage.saveToken(loginResponse.token),
        storage.saveAccessToken(loginResponse.token),
        storage.saveRefreshToken(loginResponse.refreshToken),
        storage.saveUserId(loginResponse.id),
        storage.saveEmail(loginResponse.email),
        storage.saveFirstName(loginResponse.firstName),
        storage.saveLastName(loginResponse.lastName),
      ]);

      return Right(loginResponse);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  // ── Register ──
// ── Register (النسخة المصححة) ──
  @override
  Future<Either<String, void>> register(RegisterRequest request) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      // 1. ✅ صمام الأمان: لو السيرفر رجع 200 بس جواه problemDetails (خطأ)
      if (response is Map<String, dynamic> && response['problemDetails'] != null) {
        return Left(_handleError(DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: response,
          ),
        )));
      }

      // 2. لو الباك بيرجع userId نحفظه
      if (response != null && response is Map<String, dynamic>) {
        if (response['id'] != null) {
          await storage.saveUserId(response['id'].toString());
        }
      }

      // 3. حفظ الإيميل لاستخدامه في الـ Resend
      await storage.saveEmail(request.email);

      return const Right(null); // النجاح الحقيقي
    } catch (e) {
      // 4. لو الـ Dio رمى إيرور (مثل 400 Bad Request)
      return Left(_handleError(e));
    }
  }

  // ── Confirm Email ──
  @override
  Future<Either<String, void>> confirmEmail(
      ConfirmEmailRequest request) async {
    try {
      await apiService.post(
        ApiEndpoints.confirmEmail,
        data: request.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  // ── Resend Email ──
  @override
  Future<Either<String, void>> resendConfirmEmail(
      ResendConfirmEmailRequest request) async {
    try {
      await apiService.post(
        ApiEndpoints.resendConfirmEmail,
        data: request.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  // ── Forget Password ──
  @override
  Future<Either<String, void>> forgetPassword(
      ForgetPasswordRequest request) async {
    try {
      await apiService.post(
        ApiEndpoints.forgetPassword,
        data: request.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  // ── Reset Password ──
  @override
  Future<Either<String, void>> resetPassword(
      ResetPasswordRequest request) async {
    try {
      await apiService.put(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  // ── Refresh Token ──
  @override
  Future<Either<String, LoginResponse>> refreshToken(
      RefreshTokenRequest request) async {
    try {
      final response = await apiService.put(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
      );

      if (response is! Map<String, dynamic>) {
        return const Left('Invalid refresh response');
      }

      final loginResponse = LoginResponse.fromJson(response);

      // await storage.saveToken(loginResponse.token);
      await storage.saveAccessToken(loginResponse.token);
      await storage.saveRefreshToken(loginResponse.refreshToken);

      return Right(loginResponse);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  // ── Revoke Token ──
  @override
  Future<Either<String, void>> revokeToken(
      RefreshTokenRequest request) async {
    try {
      await apiService.put(
        ApiEndpoints.revokeToken,
        data: request.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
/*
الـ DioClient بيخلق الـ Dio.

الـ ApiService بياخد الـ Dio ده.

الـ AuthRepositoryImpl بياخد الـ ApiService.
 */