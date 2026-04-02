import '../../data/models/workspace_model.dart';

abstract class WorkspaceState {}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceSuccess extends WorkspaceState {
  final List<WorkspaceModel> workspaces;

  WorkspaceSuccess(this.workspaces);
}

class WorkspaceError extends WorkspaceState {
  final String message;

  WorkspaceError(this.message);
}