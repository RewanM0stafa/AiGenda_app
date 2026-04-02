import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/workspace_repository.dart';
import 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final WorkspaceRepository repository;

  WorkspaceCubit(this.repository) : super(WorkspaceInitial());

  // 🔹 GET ALL WORKSPACES
  Future<void> getWorkspaces() async {
    try {
      emit(WorkspaceLoading());

      final workspaces = await repository.getWorkspaces();

      emit(WorkspaceSuccess(workspaces));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  // 🔹 CREATE WORKSPACE
  Future<void> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    try {
      emit(WorkspaceLoading());

      await repository.createWorkspace(
        name: name,
        description: description,
        iconCode: iconCode,
        visibility: visibility,
      );

      // 🔥 بعد الإنشاء نعمل refresh
      await getWorkspaces();
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  // 🔹 ERROR HANDLER (مهم جدًا)
  String _handleError(dynamic error) {
    // ممكن بعدين تربطيها بال DioError
    return error.toString();
  }
}