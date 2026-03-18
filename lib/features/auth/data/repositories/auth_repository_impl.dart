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
final ApiService apiService; // السواق بتاعنا
  final SecureStorageService storage;

  AuthRepositoryImpl({required this.apiService, required this.storage});

  // ── Error Handler ──
  String _handleError(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final problemDetails = data['problemDetails'];
        if (problemDetails != null) {
          final errors = problemDetails['error'] as List?;
          if (errors != null && errors.length >= 2) {
            return errors[1]; // الرسالة المقروءة
          }
          return problemDetails['title'] ?? 'Something went wrong';
        }
      }
    }
    return 'Something went wrong';
  }

  @override
  Future<Either<String, LoginResponse>> login(LoginRequest request) async {
    try {
      // بننادي على الـ service
      final response = await apiService.post(ApiEndpoints.login, data: request.toJson());
      final loginResponse = LoginResponse.fromJson(response);
      await storage.saveToken(loginResponse.token);
      await storage.saveRefreshToken(loginResponse.refreshToken);
      await storage.saveUserId(loginResponse.id);
      await storage.saveEmail(loginResponse.email);
      return Right(loginResponse);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> register(RegisterRequest request) async {
    try {
      await apiService.post(ApiEndpoints.register, data: request.toJson());
      await storage.saveEmail(request.email); // للـ resend لو احتجناه
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> confirmEmail(ConfirmEmailRequest request) async {
    try {
      await apiService.post(ApiEndpoints.confirmEmail, data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> resendConfirmEmail(ResendConfirmEmailRequest request) async {
    try {
      await apiService.post(ApiEndpoints.resendConfirmEmail, data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> forgetPassword(ForgetPasswordRequest request) async {
    try {
      await apiService.post(ApiEndpoints.forgetPassword, data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> resetPassword(ResetPasswordRequest request) async {
    try {
      await apiService.put(ApiEndpoints.resetPassword, data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, LoginResponse>> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await apiService.put(ApiEndpoints.refreshToken, data: request.toJson());
      final loginResponse = LoginResponse.fromJson(response);
      await storage.saveToken(loginResponse.token);
      await storage.saveRefreshToken(loginResponse.refreshToken);
      return Right(loginResponse);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> revokeToken(RefreshTokenRequest request) async {
    try {
      await apiService.put(ApiEndpoints.revokeToken, data: request.toJson());
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