class ApiEndpoints {
  static const String baseUrl = "https://aigenda.runasp.net";

  //  Auth Endpoints

  static const String login = "/api/Auth"; // ( post )

  static const String register = "/api/Auth/register"; // ( post )

  static const String refreshToken = "/api/Auth/refresh"; // ( put )

  static const String revokeToken = "/api/Auth/revoke-refresh-token"; // ( put )

  static const String confirmEmail = "/api/Auth/confirm-email"; // ( post )

  static const String resendConfirmEmail =
      "/api/Auth/resend-confirm-email"; // ( post )

  static const String forgetPassword = "/api/Auth/forget-password"; // ( post )

  static const String resetPassword = "/api/Auth/reset-password"; // ( put )

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
  static const String deletedWorkspaces = '/api/WorkSpaces/deleted';

  static String workspaceById(int id) => "/api/WorkSpaces/$id";

  //  Workspaces - Dashboard
  static String workspaceDashboard(int id) => '/api/WorkSpaces/$id/dashboard';
  static String workspaceRestore(int id) => '/api/WorkSpaces/$id/restore';

  //  Members
  static String members(int id) => "/api/WorkSpaces/$id/members";

  static String addMember(int id) => "/api/WorkSpaces/$id/member";
  static String removeMember(int id) => '/api/WorkSpaces/$id/remove';

  static String memberPermissions(int id, String memberUserId) =>
      '/api/WorkSpaces/$id/members/$memberUserId/permissions';

  static String updatePermissions(int id, String userId) =>
      "/api/WorkSpaces/$id/members/$userId/permissions";

  // Spaces
  static String spaces(int workspaceId) =>
      '/api/workspaces/$workspaceId/Spaces';

  static String spaceById(int workspaceId, String spaceId) =>
      '/api/workspaces/$workspaceId/Spaces/$spaceId';

  static String deletedSpaces(int workspaceId) =>
      '/api/workspaces/$workspaceId/Spaces/deleted';

  static String moveSpace(int workspaceId, String spaceId) =>
      '/api/workspaces/$workspaceId/Spaces/$spaceId/move';

  static String restoreSpace(int workspaceId, String spaceId) =>
      '/api/workspaces/$workspaceId/Spaces/$spaceId/restore';

  // Tasks
  static String tasks(int workspaceId, String spaceId) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks';

  static String taskById(int workspaceId, String spaceId, String taskId) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks/$taskId';

  static String taskStatus(int workspaceId, String spaceId, String taskId) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks/$taskId/status';

  static String taskRestore(int workspaceId, String spaceId, String taskId) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks/$taskId/restore';

  static String taskAssign(int workspaceId, String spaceId, String taskId) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks/$taskId/assign';

  static String taskUnassign(int workspaceId, String spaceId, String taskId) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks/$taskId/unassign';

  // Subtasks
  static String subTasks(int workspaceId, String spaceId, String taskId) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks/$taskId/SubTasks';

  static String subTaskById(
    int workspaceId,
    String spaceId,
    String taskId,
    String subTaskId,
  ) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks/$taskId/SubTasks/$subTaskId';

  static String subTaskStatus(
    int workspaceId,
    String spaceId,
    String taskId,
    String subTaskId,
  ) =>
      '/api/workspaces/$workspaceId/spaces/$spaceId/Tasks/$taskId/SubTasks/$subTaskId/status';
}
