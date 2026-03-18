class ApiEndpoints {

  static const String baseUrl = "https://aigenda.runasp.net";

  //  Auth Endpoints

  static const String login = "/api/Auth"; // ( post )

  static const String register = "/api/Auth/register";  // ( post )

  static const String refreshToken = "/api/Auth/refresh";  // ( put )

  static const String revokeToken = "/api/Auth/revoke-refresh-token";  // ( put )


  static const String confirmEmail = "/api/Auth/confirm-email"; // ( post )

  static const String resendConfirmEmail = "/api/Auth/resend-confirm-email";  // ( post )

  static const String forgetPassword = "/api/Auth/forget-password";  // ( post )

  static const String resetPassword = "/api/Auth/reset-password";  // ( put )


}
