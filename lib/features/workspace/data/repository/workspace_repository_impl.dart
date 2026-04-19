import '../../../../core/models/filter_request.dart';
import '../../../../core/models/paginated_response.dart';
import '../../domain/workspace_repository.dart';
import '../data_source/workspace_remote_data_source.dart';
import '../models/member_model.dart';
import '../models/workspace_dashboard_model.dart';
import '../models/workspace_model.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remote;

  WorkspaceRepositoryImpl(this.remote);

  @override
  Future<PaginatedResponse<WorkspaceModel>> getWorkspaces({
    FilterRequest filter = const FilterRequest(),
  }) => remote.getWorkspaces(filter: filter);

  @override
  Future<WorkspaceModel> getWorkspaceById(int id) =>
      remote.getWorkspaceById(id);

  @override
  Future<void> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) => remote.createWorkspace(
    name: name,
    description: description,
    iconCode: iconCode,
    visibility: visibility,
  );

  @override
  Future<void> updateWorkspace({
    required int id,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) => remote.updateWorkspace(
    id: id,
    name: name,
    description: description,
    iconCode: iconCode,
    visibility: visibility,
  );

  @override
  Future<void> deleteWorkspace(int id) => remote.deleteWorkspace(id);

  @override
  Future<void> restoreWorkspace(int id) => remote.restoreWorkspace(id);

  @override
  Future<List<WorkspaceModel>> getDeletedWorkspaces() =>
      remote.getDeletedWorkspaces();

  @override
  Future<WorkspaceDashboardModel> getDashboard(int id) =>
      remote.getDashboard(id);

  @override
  Future<List<MemberModel>> getMembers(int id) => remote.getMembers(id);

  @override
  Future<void> addMember(int id, String email) =>
      remote.addMember(id, email);

  @override
  Future<void> removeMember(int id, String email) =>
      remote.removeMember(id, email);

  @override
  Future<List<String>> getMemberPermissions(int id, String memberUserId) =>
      remote.getMemberPermissions(id, memberUserId);

  @override
  Future<void> updateMemberPermissions(
      int id,
      String memberUserId,
      List<String> permissions,
      ) => remote.updateMemberPermissions(id, memberUserId, permissions);
}