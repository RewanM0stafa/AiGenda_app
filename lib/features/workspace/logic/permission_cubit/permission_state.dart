import '../../../roles/models/workspce_role.dart';

abstract class PermissionsState {}

class PermissionsInitial extends PermissionsState {}

class PermissionsLoaded extends PermissionsState {
  final List<String> selectedPermissions;
  final WorkspaceRole role;
  final bool isLoading;
  final bool canUserModify;

  PermissionsLoaded({
    required this.selectedPermissions,
    required this.role,
    this.isLoading = false,
    this.canUserModify = false,
  });

  PermissionsLoaded copyWith({
    List<String>? selectedPermissions,
    WorkspaceRole? role,
    bool? isLoading,
    bool? canUserModify,
  }) {
    return PermissionsLoaded(
      selectedPermissions: selectedPermissions ?? this.selectedPermissions,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      canUserModify: canUserModify ?? this.canUserModify,
    );
  }
}
class PermissionsUpdateSuccess extends PermissionsState {
  final String message;
  PermissionsUpdateSuccess({this.message = "Permissions updated successfully "});
} 

class PermissionsError extends PermissionsState {
  final String message;

  PermissionsError(this.message);
}