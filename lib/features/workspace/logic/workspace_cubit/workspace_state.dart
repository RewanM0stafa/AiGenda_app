import '../../../../core/models/paginated_response.dart';
import '../../data/models/workspace_dashboard_model.dart';
import '../../data/models/workspace_model.dart';

abstract class WorkspaceState {}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspacesSuccess extends WorkspaceState {
  final PaginatedResponse<WorkspaceModel> data;
  WorkspacesSuccess(this.data);
}

class WorkspaceDetailSuccess extends WorkspaceState {
  final WorkspaceModel workspace;
  WorkspaceDetailSuccess(this.workspace);
}

class WorkspaceDashboardSuccess extends WorkspaceState {
  final WorkspaceDashboardModel dashboard;
  WorkspaceDashboardSuccess(this.dashboard);
}

class DeletedWorkspacesSuccess extends WorkspaceState {
  final List<WorkspaceModel> workspaces;
  DeletedWorkspacesSuccess(this.workspaces);
}

class WorkspaceActionSuccess extends WorkspaceState {}

class WorkspaceError extends WorkspaceState {
  final String message;
  WorkspaceError(this.message);
}