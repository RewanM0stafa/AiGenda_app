import 'package:ajenda_app/features/workspace/logic/permission_cubit/permission_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_permissions.dart';
import '../../../roles/models/workspce_role.dart';
import '../../../roles/utils/role_permissions_mapper.dart';
import '../../domain/workspace_repository.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  final WorkspaceRepository repository;

  PermissionsCubit(this.repository) : super(PermissionsInitial());

  Future<void> loadPermissions(int workspaceId, String memberUserId) async {
    try {
      emit(PermissionsLoading());
      final permissions = await repository.getMemberPermissions(
        workspaceId,
        memberUserId,
      );
      final role = _detectRole(permissions);
      emit(PermissionsLoaded(selectedPermissions: permissions, role: role));
    } catch (e) {
      emit(PermissionsError(e.toString()));
    }
  }

  void changeRole(WorkspaceRole role) {
    final permissions = RolePermissionsMapper.map(role);
    emit(PermissionsLoaded(selectedPermissions: permissions, role: role));
  }

  void togglePermission(String permission) {
    if (state is! PermissionsLoaded) return;
    final current = state as PermissionsLoaded;
    final updated = List<String>.from(current.selectedPermissions);

    if (updated.contains(permission)) {
      updated.remove(permission);
    } else {
      updated.add(permission);
    }

    emit(
      current.copyWith(
        selectedPermissions: updated,
        role: WorkspaceRole.custom,
      ),
    );
  }

  Future<void> updatePermissions({
    required int workspaceId,
    required String memberUserId,
  }) async {
    if (state is! PermissionsLoaded) return;
    final current = state as PermissionsLoaded;

    try {
      emit(current.copyWith(isLoading: true));

      final List<String> defaultPermissions = [
        AppPermissions.workspacesRead,
        AppPermissions.spacesRead,
        AppPermissions.tasksRead,
        AppPermissions.notesRead,
      ];

      final permissionsToSend = current.selectedPermissions
          .where((p) => !defaultPermissions.contains(p))
          .toList();

      await repository.updateMemberPermissions(
        workspaceId,
        memberUserId,
        permissionsToSend,
      );

      emit(current.copyWith(isLoading: false));
    } catch (e) {
      emit(PermissionsError(e.toString()));
    }
  }

  WorkspaceRole _detectRole(List<String> permissions) {
    final extra = permissions
        .where((p) => AppPermissions.all.contains(p))
        .toSet();

    if (extra.isEmpty) return WorkspaceRole.viewer;

    if (_setEquals(
      extra,
      RolePermissionsMapper.map(WorkspaceRole.admin).toSet(),
    )) {
      return WorkspaceRole.admin;
    }

    if (_setEquals(
      extra,
      RolePermissionsMapper.map(WorkspaceRole.editor).toSet(),
    )) {
      return WorkspaceRole.editor;
    }

    return WorkspaceRole.custom;
  }

  bool _setEquals(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);
}
