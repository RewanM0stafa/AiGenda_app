
import 'package:dartz/dartz.dart';

import '../../data/models/login/login_request_model.dart';
import '../../data/models/login/login_response_model.dart';
import '../../data/models/password/forget_password_request_model.dart';
import '../../data/models/password/reset_password_request_model.dart';
import '../../data/models/register/confirm_email_request_model.dart';
import '../../data/models/register/register_request_model.dart';
import '../../data/models/register/resend_confirm_email_request_model.dart';
import '../../data/models/token/refresh_token_request_model.dart';

abstract class AuthRepository {
  Future<Either<String, LoginResponse>> login(LoginRequest request);
  Future<Either<String, void>> register(RegisterRequest request);
  Future<Either<String, void>> confirmEmail(ConfirmEmailRequest request);
  Future<Either<String, void>> resendConfirmEmail(ResendConfirmEmailRequest request);
  Future<Either<String, void>> forgetPassword(ForgetPasswordRequest request);
  Future<Either<String, void>> resetPassword(ResetPasswordRequest request);
  Future<Either<String, LoginResponse>> refreshToken(RefreshTokenRequest request);
  Future<Either<String, void>> revokeToken(RefreshTokenRequest request);
}





/*
abstract class AuthRepository {
  // بنستخدم Either عشان نرجع يا إما Error (يمين) يا إما النجاح (شمال)
  // ده بيخلي الـ Error Handling احترافي جداً
  Future<Either<String, LoginResponse>> login(LoginRequest loginRequest);
}
*/
