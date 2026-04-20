// logic/workspace_cubit/workspace_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/workspace_repository.dart';
import 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final WorkspaceRepository repository;
  WorkspaceCubit(this.repository) : super(WorkspaceInitial());


  Future<void> getWorkspaces() async {
    try {
      emit(WorkspaceLoading());
      emit(WorkspaceSuccess(await repository.getWorkspaces()));
    } catch (e) {
      emit(WorkspaceError(e.toString()));
    }
  }

  Future<int?> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    try {
      emit(WorkspaceLoading());
      final newId = await repository.createWorkspace(
        name: name,
        description: description,
        iconCode: iconCode,
        visibility: visibility,
      );
      await getWorkspaces();
      return newId;
    } catch (e) {
      emit(WorkspaceError(e.toString()));
      return null;
    }
  }

  Future<bool> editWorkspace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
    required bool isOwner,
  }) async {
    if (!isOwner) {
      emit(WorkspaceError("You don't have permission to edit this workspace."));
      return false;
    }
    try {
      await repository.editWorkspace(
        workspaceId: workspaceId,
        name: name,
        description: description,
        iconCode: iconCode,
        visibility: visibility,
      );
      await getWorkspaces();
      return true;
    } catch (e) {
      emit(WorkspaceError(e.toString()));
      return false;
    }
  }

  Future<bool> deleteWorkspace(int workspaceId, {required bool isOwner}) async {
    if (!isOwner) {
      emit(WorkspaceError("You don't have permission to delete this workspace."));
      return false;
    }
    try {
      await repository.deleteWorkspace(workspaceId);
      await getWorkspaces();
      return true;
    } catch (e) {
      emit(WorkspaceError(e.toString()));
      return false;
    }
  }

  Future<bool> leaveWorkspace(int workspaceId, String email) async {
    try {
      await repository.leaveWorkspace(workspaceId, email);
      final workspaces = await repository.getWorkspaces();
      emit(WorkspaceSuccess(workspaces));
      return true;
    } catch (e) {
      emit(WorkspaceError(e.toString()));
      return false;
    }
  }

  Future<void> addMember(
    int workspaceId, 
    String email,
    List<String> permissions) 
    async {
    try {
      await repository.addMember(workspaceId, email, permissions);
    } catch (_) {}
  }
}
