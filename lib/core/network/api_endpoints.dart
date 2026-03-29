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


  // Profile / Me
  static const String me = '/me';
  static const String updateMe = '/me';
  static const String changePassword = '/me/change-password';
  static const String changeEmail = '/me/change-email';
  static const String confirmChangeEmail = '/me/confirm-change-email';

  // Avatar
  static const String uploadAvatar = '/me/avatar';
  static const String getAvatar = '/me/avatar';
  static const String deleteAvatar = '/me/avatar';


  // Roles
  static const roles = "/api/Roles";

  // Workspaces
  static const workspaces = "/api/WorkSpaces";

  static String workspaceById(int id) =>
  "/api/WorkSpaces/$id";

  static String members(int id) =>
  "/api/WorkSpaces/$id/members";

  static String addMember(int id) =>
  "/api/WorkSpaces/$id/member";

  static String updatePermissions(int id, String userId) =>
  "/api/WorkSpaces/$id/members/$userId/permissions";
  }
