import '../../../roles/models/workspce_role.dart';

abstract class PermissionsState {}

class PermissionsInitial extends PermissionsState {}

class PermissionsLoaded extends PermissionsState {
  final List<String> selectedPermissions;
  final WorkspaceRole role;
  final bool isLoading;

  PermissionsLoaded({
    required this.selectedPermissions,
    required this.role,
    this.isLoading = false,
  });

  PermissionsLoaded copyWith({
    List<String>? selectedPermissions,
    WorkspaceRole? role,
    bool? isLoading,
  }) {
    return PermissionsLoaded(
      selectedPermissions:
      selectedPermissions ?? this.selectedPermissions,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PermissionsError extends PermissionsState {
  final String message;

  PermissionsError(this.message);
}