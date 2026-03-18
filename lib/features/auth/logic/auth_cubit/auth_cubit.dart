import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/models/login/login_request_model.dart';
import '../../data/models/password/forget_password_request_model.dart';
import '../../data/models/password/reset_password_request_model.dart';
import '../../data/models/register/confirm_email_request_model.dart';
import '../../data/models/register/register_request_model.dart';
import '../../data/models/register/resend_confirm_email_request_model.dart';
import '../../data/models/token/refresh_token_request_model.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final SecureStorageService storage;

  AuthCubit(this.authRepository, this.storage) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    final result = await authRepository.login(
      LoginRequest(email: email, password: password),
    );
    result.fold(
          (failure) => emit(LoginFailure(errMessage: failure)),
          (response) => emit(LoginSuccess(token: response.token)),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(RegisterLoading());
    final result = await authRepository.register(
      RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
    result.fold(
          (failure) => emit(RegisterFailure(errMessage: failure)),
          (_) => emit(RegisterSuccess()),
    );
  }

  Future<void> confirmEmail({
    required String userId,
    required String code,
  }) async {
    emit(ConfirmEmailLoading());
    final result = await authRepository.confirmEmail(
      ConfirmEmailRequest(userId: userId, code: code),
    );
    result.fold(
          (failure) => emit(ConfirmEmailFailure(errMessage: failure)),
          (_) => emit(ConfirmEmailSuccess()),
    );
  }

  Future<void> resendConfirmEmail() async {
    emit(ResendEmailLoading());
    // ← بياخد الـ email من الـ storage تلقائي
    final email = await storage.getEmail();
    if (email == null) {
      emit(ResendEmailFailure(errMessage: 'Email not found. Please register again.'));
      return;
    }
    final result = await authRepository.resendConfirmEmail(
      ResendConfirmEmailRequest(email: email),
    );
    result.fold(
          (failure) => emit(ResendEmailFailure(errMessage: failure)),
          (_) => emit(ResendEmailSuccess()),
    );
  }

  Future<void> forgetPassword({required String email}) async {
    emit(ForgetPasswordLoading());
    final result = await authRepository.forgetPassword(
      ForgetPasswordRequest(email: email),
    );
    result.fold(
          (failure) => emit(ForgetPasswordFailure(errMessage: failure)),
          (_) => emit(ForgetPasswordSuccess()),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());
    final result = await authRepository.resetPassword(
      ResetPasswordRequest(email: email, code: code, newPassword: newPassword),
    );
    result.fold(
          (failure) => emit(ResetPasswordFailure(errMessage: failure)),
          (_) => emit(ResetPasswordSuccess()),
    );
  }

  Future<void> logout() async {
    emit(LogoutLoading());
    final token = await storage.getToken();
    final refreshToken = await storage.getRefreshToken();

    if (token == null || refreshToken == null) {
      await storage.clearAll();
      emit(LogoutSuccess());
      return;
    }

    await authRepository.revokeToken(
      RefreshTokenRequest(token: token, refreshToken: refreshToken),
    );

    // ✅ حتى لو فشل الـ API — امسح الـ storage وخرج اليوزر
    await storage.clearAll();
    emit(LogoutSuccess());
  }
}