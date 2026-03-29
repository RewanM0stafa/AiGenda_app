import 'package:ajenda_app/features/worksspace/logic/permission_cubit/permission_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_permissions.dart';
import '../../../roles/models/workspce_role.dart';
import '../../../roles/utils/role_permissions_mapper.dart';
import '../../domain/workspace_repository.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  final WorkspaceRepository repository;

  PermissionsCubit(this.repository) : super(PermissionsInitial());

  void init(List<String> currentPermissions) {
    final detectedRole = _detectRole(currentPermissions);

    emit(
      PermissionsLoaded(
        selectedPermissions: currentPermissions,
        role: detectedRole,
      ),
    );
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

    emit(current.copyWith(
      selectedPermissions: updated,
      role: WorkspaceRole.custom,
    ));
  }

  Future<void> updatePermissions({
    required int workspaceId,
    required String userId,
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

      await repository.updatePermissions(
        workspaceId,
        userId,
        permissionsToSend,
      );

      emit(current.copyWith(isLoading: false));
    } catch (e) {
      emit(PermissionsError(e.toString()));
    }
  }

  WorkspaceRole _detectRole(List<String> userPermissions) {
    final userExtra = userPermissions.where((p) => AppPermissions.all.contains(p)).toSet();

    // 2. المقارنة
    if (userExtra.isEmpty) return WorkspaceRole.viewer;

    if (_setEquals(userExtra, RolePermissionsMapper.map(WorkspaceRole.admin).toSet())) {
      return WorkspaceRole.admin;
    }

    if (_setEquals(userExtra, RolePermissionsMapper.map(WorkspaceRole.editor).toSet())) {
      return WorkspaceRole.editor;
    }

    return WorkspaceRole.custom;
  }

  bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

}