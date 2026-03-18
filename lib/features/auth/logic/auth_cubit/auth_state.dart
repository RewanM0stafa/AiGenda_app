// إيه الاحتمالات والحالات اللي الداتا ممكن تؤثر بيها ع ال ui

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
class RegisterSuccess extends AuthState {}
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

// ── Resend Email ──
class ResendEmailLoading extends AuthState {}
class ResendEmailSuccess extends AuthState {}
class ResendEmailFailure extends AuthState {
  final String errMessage;
  ResendEmailFailure({required this.errMessage});
}

// ── Forget Password ──
class ForgetPasswordLoading extends AuthState {}
class ForgetPasswordSuccess extends AuthState {}
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

// ── Logout ──
class LogoutLoading extends AuthState {}
class LogoutSuccess extends AuthState {}
class LogoutFailure extends AuthState {
  final String errMessage;
  LogoutFailure({required this.errMessage});
}