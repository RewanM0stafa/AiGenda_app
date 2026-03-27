// إيه الاحتمالات والحالات اللي الداتا ممكن تؤثر بيها ع ال ui
/*
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final String userId;
  final String firstName;
  final String secondName;

  AuthSuccess({
    required this.token,
    required this.userId,
    required this.firstName,
    required this.secondName,
  });
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class RegisterSuccess extends AuthState {
  final String email;
  RegisterSuccess(this.email);
}

class ConfirmEmailSuccess extends AuthState {}

class LogoutSuccess extends AuthState {}

/*

abstract class AuthState {}

class AuthInitial extends AuthState {}

// ── Login ──
class LoginLoading extends AuthState {}
class LoginSuccess extends AuthState {
  final String token;
  LoginSuccess({required this.token});
}
class LoginFailure extends AuthState {
  final String errMessage;
  LoginFailure({required this.errMessage});
}

// ── Register ──
class RegisterLoading extends AuthState {}
class RegisterSuccess extends AuthState {
  final String email; // للـ confirm screen
  RegisterSuccess({required this.email});
}
class RegisterFailure extends AuthState {
  final String errMessage;
  RegisterFailure({required this.errMessage});
}



// ── Confirm Email ──
class ConfirmEmailLoading extends AuthState {}
class ConfirmEmailSuccess extends AuthState {}
class ConfirmEmailFailure extends AuthState {
  final String errMessage;
  ConfirmEmailFailure({required this.errMessage});
}
*/

// ── Resend Email ──
class ResendEmailLoading extends AuthState {}
class ResendEmailSuccess extends AuthState {}
class ResendEmailFailure extends AuthState {
  final String errMessage;
  ResendEmailFailure({required this.errMessage});
}

// ── Forget Password ──
class ForgetPasswordLoading extends AuthState {}
class ForgetPasswordSuccess extends AuthState {
  final String email; // للـ reset screen
  ForgetPasswordSuccess({required this.email});
}
class ForgetPasswordFailure extends AuthState {
  final String errMessage;
  ForgetPasswordFailure({required this.errMessage});
}

// ── Reset Password ──
class ResetPasswordLoading extends AuthState {}
class ResetPasswordSuccess extends AuthState {}
class ResetPasswordFailure extends AuthState {
  final String errMessage;
  ResetPasswordFailure({required this.errMessage});
}
*/
/*
// ── Logout ──
class LogoutLoading extends AuthState {}
class LogoutSuccess extends AuthState {}
class LogoutFailure extends AuthState {
  final String errMessage;
  LogoutFailure({required this.errMessage});
}

 */

// 📁 features/auth/logic/auth_cubit/auth_state.dart

abstract class AuthState {}

class AuthInitial extends AuthState {}

// ── Login ──
class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String token;
  final String userId;
  final String firstName;
  final String lastName;

  LoginSuccess({
    required this.token,
    required this.userId,
    required this.firstName,
    required this.lastName,
  });
}

class LoginFailure extends AuthState {
  final String message;
  LoginFailure(this.message);
}

// ── Register ──
class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String email; // بنبعته للـ ConfirmEmailScreen
  RegisterSuccess(this.email);
}

class RegisterFailure extends AuthState {
  final String message;
  RegisterFailure(this.message);
}

// ── Confirm Email ──
class ConfirmEmailLoading extends AuthState {}
class ConfirmEmailSuccess extends AuthState {}

class ConfirmEmailFailure extends AuthState {
  final String message;
  ConfirmEmailFailure(this.message);
}

// ── Resend Email ──
class ResendEmailLoading extends AuthState {}
class ResendEmailSuccess extends AuthState {}

class ResendEmailFailure extends AuthState {
  final String message;
  ResendEmailFailure(this.message);
}

// ── Forget Password ──
class ForgetPasswordLoading extends AuthState {}

class ForgetPasswordSuccess extends AuthState {
  final String email; // بنبعته للـ EnterCodeScreen
  ForgetPasswordSuccess(this.email);
}

class ForgetPasswordFailure extends AuthState {
  final String message;
  ForgetPasswordFailure(this.message);
}

// ── Reset Password ──
class ResetPasswordLoading extends AuthState {}
class ResetPasswordSuccess extends AuthState {}

class ResetPasswordFailure extends AuthState {
  final String message;
  ResetPasswordFailure(this.message);
}

// ── Logout ──
class LogoutLoading extends AuthState {}
class LogoutSuccess extends AuthState {}

class LogoutFailure extends AuthState {
  final String message;
  LogoutFailure(this.message);
}
