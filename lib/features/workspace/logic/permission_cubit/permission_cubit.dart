import 'package:ajenda_app/features/worksspace/logic/permission_cubit/permission_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_permissions.dart';
import '../../../roles/models/workspce_role.dart';
import '../../../roles/utils/role_permissions_mapper.dart';
import '../../domain/workspace_repository.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  final WorkspaceRepository repository;

  PermissionsCubit(this.repository) : super(PermissionsInitial());

  void init(List<String> currentPermissions, {bool canUserModify = false}) {
    // print('PermissionsCubit.init: canUserModify = $canUserModify');
    // final detectedRole = _detectRole(currentPermissions);

    emit(
      PermissionsLoaded(
        selectedPermissions: currentPermissions,
        role: _detectRole(currentPermissions),
        canUserModify: canUserModify,
      ),
    );
  }

  void changeRole(WorkspaceRole role) {
    if(state is! PermissionsLoaded) return;
    final current = state as PermissionsLoaded;
    //final permissions = RolePermissionsMapper.map(role);
    emit(current.copyWith(
      selectedPermissions: RolePermissionsMapper.map(role), 
      role: role));
  }

  void togglePermission(String permission) {
    if (state is! PermissionsLoaded) return;
    final current = state as PermissionsLoaded;
    final updated = List<String>.from(current.selectedPermissions);

     updated.contains(permission) 
        ? updated.remove(permission) 
        : updated.add(permission);

    emit(
      current.copyWith(
        selectedPermissions: updated,
        role: WorkspaceRole.custom,
      ),
    );
  }

  Future<void> updatePermissions({
    required int workspaceId,
    required String userId,
    required bool canUserModify,
  }) async {
  if (!canUserModify) {
      emit(PermissionsError("You don't have permission to modify this user's permissions."));
      return;
    }

    if (state is! PermissionsLoaded) return;
    final current = state as PermissionsLoaded;

    try {
      emit(current.copyWith(isLoading: true));

      const defaultPermissions = [
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
      emit(PermissionsUpdateSuccess());
      //emit(current.copyWith(isLoading: false));
    } catch (e) {
      emit(current.copyWith(isLoading: false));
      emit(PermissionsError(e.toString()));
    }
  }

  WorkspaceRole _detectRole(List<String> userPermissions) {
    final userExtra = userPermissions
        .where((p) => AppPermissions.all.contains(p))
        .toSet();

    if (userExtra.isEmpty) return WorkspaceRole.viewer;

    if (_setEquals(
      userExtra,
      RolePermissionsMapper.map(WorkspaceRole.admin).toSet(),
    )) {
      return WorkspaceRole.admin;
    }

    if (_setEquals(
      userExtra,
      RolePermissionsMapper.map(WorkspaceRole.editor).toSet(),
    )) {
      return WorkspaceRole.editor;
    }

    return WorkspaceRole.custom;
  }
   bool _setEquals(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);

  // bool _setEquals(Set<String> a, Set<String> b) {
  //   if (a.length != b.length) return false;
  //   return a.containsAll(b);
  // }
}
