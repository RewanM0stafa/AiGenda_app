import '../../../core/constants/app_permissions.dart';
import '../models/workspce_role.dart';

class RolePermissionsMapper {
  static List<String> map(WorkspaceRole role) {
    switch (role) {
      case WorkspaceRole.admin:
        return AppPermissions.all;

      case WorkspaceRole.editor:
        return [
          AppPermissions.spacesAdd,
          AppPermissions.tasksAdd,
          AppPermissions.tasksUpdate,
          AppPermissions.notesAdd,
          AppPermissions.notesUpdate,
        ];

      case WorkspaceRole.viewer:
        return [];

      case WorkspaceRole.custom:
        return [];
    }
  }
}