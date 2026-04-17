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

  // ✅ Returns new ID so we can save color
  Future<int?> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    try {
      emit(WorkspaceLoading());
      final newId = await repository.createWorkspace(
        name: name, description: description,
        iconCode: iconCode, visibility: visibility,
      );
      await getWorkspaces();
      return newId;
    } catch (e) {
      emit(WorkspaceError(e.toString()));
      return null;
    }
  }

  // ✅ New — calls PUT API
  Future<bool> editWorkspace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    try {
      await repository.editWorkspace(
        workspaceId: workspaceId, name: name,
        description: description, iconCode: iconCode, visibility: visibility,
      );
      await getWorkspaces();
      return true;
    } catch (e) {
      emit(WorkspaceError(e.toString()));
      return false;
    }
  }

  Future<bool> deleteWorkspace(int id) async {
    try {
      await repository.deleteWorkspace(id);
      await getWorkspaces();
      return true;
    } catch (e) {
      emit(WorkspaceError(e.toString()));
      return false;
    }
  }

  Future<bool> leaveWorkspace(int id) async {
    try {
      await repository.leaveWorkspace(id);
      await getWorkspaces();
      return true;
    } catch (e) {
      emit(WorkspaceError(e.toString()));
      return false;
    }
  }

  Future<void> addMember(int workspaceId, String email) async {
    try {
      await repository.addMember(workspaceId, email);
    } catch (_) {}
  }
}