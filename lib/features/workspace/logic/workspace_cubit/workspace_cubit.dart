import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/filter_request.dart';
import '../../domain/workspace_repository.dart';
import 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final WorkspaceRepository repository;

  WorkspaceCubit(this.repository) : super(WorkspaceInitial());

  //  CRUD

  Future<void> getWorkspaces({
    FilterRequest filter = const FilterRequest(),
  }) async {
    try {
      emit(WorkspaceLoading());
      final data = await repository.getWorkspaces(filter: filter);
      emit(WorkspacesSuccess(data));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  Future<void> getWorkspaceById(int id) async {
    try {
      emit(WorkspaceLoading());
      final workspace = await repository.getWorkspaceById(id);
      emit(WorkspaceDetailSuccess(workspace));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

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
      await getWorkspaces();
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  Future<void> updateWorkspace({
    required int id,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    try {
      emit(WorkspaceLoading());
      await repository.updateWorkspace(
        id: id,
        name: name,
        description: description,
        iconCode: iconCode,
        visibility: visibility,
      );
      await getWorkspaces();
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  Future<void> deleteWorkspace(int id) async {
    try {
      emit(WorkspaceLoading());
      await repository.deleteWorkspace(id);
      await getWorkspaces();
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  Future<void> restoreWorkspace(int id) async {
    try {
      emit(WorkspaceLoading());
      await repository.restoreWorkspace(id);
      emit(WorkspaceActionSuccess());
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  Future<void> getDeletedWorkspaces() async {
    try {
      emit(WorkspaceLoading());
      final list = await repository.getDeletedWorkspaces();
      emit(DeletedWorkspacesSuccess(list));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  //  Dashboard

  Future<void> getDashboard(int id) async {
    try {
      emit(WorkspaceLoading());
      final dashboard = await repository.getDashboard(id);
      emit(WorkspaceDashboardSuccess(dashboard));
    } catch (e) {
      emit(WorkspaceError(_handleError(e)));
    }
  }

  //  Error Handler

  String _handleError(dynamic error) => error.toString();
}