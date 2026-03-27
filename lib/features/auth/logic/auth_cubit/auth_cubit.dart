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

/*
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  final SecureStorageService storage;

  AuthCubit(this.repo, this.storage) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await repo.login(
      LoginRequest(email: email, password: password),
    );

    result.fold(
          (err) => emit(AuthFailure(err)),
          (res) => emit(AuthSuccess(
        token: res.token,
        userId: res.id,
        firstName: res.firstName,
        secondName: res.secondName,
      )),
    );
  }

  Future<void> register(RegisterRequest request) async {
    emit(AuthLoading());

    final result = await repo.register(request);

    result.fold(
          (err) => emit(AuthFailure(err)),
          (_) => emit(RegisterSuccess(request.email)),
    );
  }

  Future<void> confirmEmail(String userId, String code) async {
    emit(AuthLoading());

    final result = await repo.confirmEmail(
      ConfirmEmailRequest(userId: userId, code: code),
    );

    result.fold(
          (err) => emit(AuthFailure(err)),
          (_) => emit(ConfirmEmailSuccess()),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());

    final token = await storage.getToken();
    final refresh = await storage.getRefreshToken();

    if (token != null && refresh != null) {
      await repo.revokeToken(
        RefreshTokenRequest(token: token, refreshToken: refresh),
      );
    }

    await storage.clearAll();
    emit(LogoutSuccess());
  }
}
*/

/*
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final SecureStorageService storage;

  AuthCubit(this.authRepository, this.storage) : super(AuthInitial());



  Future<void> login({
    required String email,
    required String password,
  }) async {
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
      // نبعت الـ email في الـ state عشان الـ confirm screen يستخدمه
          (_) => emit(RegisterSuccess(email: email)),
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

  Future<void> resendConfirmEmail({required String email}) async {
    emit(ResendEmailLoading());
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
      // نبعت الـ email في الـ state عشان الـ reset screen يستخدمه
          (_) => emit(ForgetPasswordSuccess(email: email)),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());
    final result = await authRepository.resetPassword(
      ResetPasswordRequest(
          email: email, code: code, newPassword: newPassword),
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

    if (token != null && refreshToken != null) {
      await authRepository.revokeToken(
        RefreshTokenRequest(token: token, refreshToken: refreshToken),
      );
    }

    // ✅ امسح دايماً بغض النظر عن نتيجة الـ API
    await storage.clearAll();
    emit(LogoutSuccess());
  }
}
*/

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

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  final SecureStorageService storage;

  AuthCubit(this.repo, this.storage) : super(AuthInitial());

  // ─────────── LOGIN ───────────
  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    final result = await repo.login(
      LoginRequest(email: email, password: password),
    );

    await result.fold(
          (err) async {
        emit(LoginFailure(err));
      },
          (res) async {
        // ✅ حفظ التوكن (أهم خطوة)
        await storage.saveAccessToken(res.token);
        final token = await storage.getAccessToken();
        print("TOKEN AFTER LOGIN: $token");
        // ✅ لو فيه refresh token
        if (res.refreshToken != null) {
          await storage.saveRefreshToken(res.refreshToken);
        }

        // ✅ حفظ بيانات اليوزر (اختياري بس مفيد)
        await storage.saveUserData(
          userId: res.id,
          email: res.email,
          firstName: res.firstName,
          lastName: res.lastName,
        );

        emit(LoginSuccess(
          token: res.token,
          userId: res.id,
          firstName: res.firstName,
          lastName: res.lastName,
        ));
      },
    );
  }

  // ─────────── REGISTER ───────────
  Future<void> register(RegisterRequest request) async {
    emit(RegisterLoading());

    final result = await repo.register(request);

    result.fold(
          (err) => emit(RegisterFailure(err)),
          (_) => emit(RegisterSuccess(request.email)),
    );
  }

  // ─────────── CONFIRM EMAIL ───────────
  Future<void> confirmEmail(String userId, String code) async {
    emit(ConfirmEmailLoading());

    final result = await repo.confirmEmail(
      ConfirmEmailRequest(userId: userId, code: code),
    );

    result.fold(
          (err) => emit(ConfirmEmailFailure(err)),
          (_) => emit(ConfirmEmailSuccess()),
    );
  }

  // ─────────── RESEND EMAIL ───────────
  Future<void> resendConfirmEmail(String email) async {
    emit(ResendEmailLoading());

    final result = await repo.resendConfirmEmail(
      ResendConfirmEmailRequest(email: email),
    );

    result.fold(
          (err) => emit(ResendEmailFailure(err)),
          (_) => emit(ResendEmailSuccess()),
    );
  }

  // ─────────── FORGET PASSWORD ───────────
  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoading());

    final result = await repo.forgetPassword(
      ForgetPasswordRequest(email: email),
    );

    result.fold(
          (err) => emit(ForgetPasswordFailure(err)),
          (_) => emit(ForgetPasswordSuccess(email)),
    );
  }

  // ─────────── RESET PASSWORD ───────────
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());

    final result = await repo.resetPassword(
      ResetPasswordRequest(
        email: email,
        code: code,
        newPassword: newPassword,
      ),
    );

    result.fold(
          (err) => emit(ResetPasswordFailure(err)),
          (_) => emit(ResetPasswordSuccess()),
    );
  }

  // ─────────── LOGOUT ───────────
  Future<void> logout() async {
    emit(LogoutLoading());

    final token = await storage.getAccessToken();
    final refresh = await storage.getRefreshToken();

    if (token != null && refresh != null) {
      await repo.revokeToken(
        RefreshTokenRequest(token: token, refreshToken: refresh),
      );
    }

    await storage.clearAll();
    emit(LogoutSuccess());
  }
}