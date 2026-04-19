import '../../../../core/models/filter_request.dart';
import '../../../../core/models/paginated_response.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_keys.dart';
import '../../../../core/network/api_service.dart';
import '../models/member_model.dart';
import '../models/workspace_dashboard_model.dart';
import '../models/workspace_model.dart';

class WorkspaceRemoteDataSource {
  final ApiService apiService;

  WorkspaceRemoteDataSource(this.apiService);

  Future<PaginatedResponse<WorkspaceModel>> getWorkspaces({
    FilterRequest filter = const FilterRequest(),
  }) async {
    final data = await apiService.get(
      ApiEndpoints.workspaces,
      queryParameters: filter.toQueryParams(),
    );
    return PaginatedResponse.fromJson(data, WorkspaceModel.fromJson);
  }

  Future<WorkspaceModel> getWorkspaceById(int id) async {
    final data = await apiService.get(ApiEndpoints.workspaceById(id));
    return WorkspaceModel.fromJson(data);
  }

  Future<void> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    await apiService.post(
      ApiEndpoints.workspaces,
      data: {
        ApiKeys.name: name,
        ApiKeys.description: description,
        ApiKeys.iconCode: iconCode,
        ApiKeys.visibility: visibility,
      },
    );
  }

  Future<void> updateWorkspace({
    required int id,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    await apiService.put(
      ApiEndpoints.workspaceById(id),
      data: {
        ApiKeys.name: name,
        ApiKeys.description: description,
        ApiKeys.iconCode: iconCode,
        ApiKeys.visibility: visibility,
      },
    );
  }

  Future<void> deleteWorkspace(int id) async {
    await apiService.delete(ApiEndpoints.workspaceById(id));
  }

  Future<void> restoreWorkspace(int id) async {
    await apiService.put(ApiEndpoints.workspaceRestore(id));
  }

  Future<List<WorkspaceModel>> getDeletedWorkspaces() async {
    final data = await apiService.get(ApiEndpoints.deletedWorkspaces);
    return (data as List).map((e) => WorkspaceModel.fromJson(e)).toList();
  }

  Future<WorkspaceDashboardModel> getDashboard(int id) async {
    final data = await apiService.get(ApiEndpoints.workspaceDashboard(id));
    return WorkspaceDashboardModel.fromJson(data);
  }

  Future<List<MemberModel>> getMembers(int id) async {
    final data = await apiService.get(ApiEndpoints.members(id));
    return (data as List).map((e) => MemberModel.fromJson(e)).toList();
  }

  Future<void> addMember(int id, String email) async {
    await apiService.post(
      ApiEndpoints.addMember(id),
      data: {ApiKeys.email: email},
    );
  }

  Future<void> removeMember(int id, String email) async {
    await apiService.delete(
      ApiEndpoints.removeMember(id),
      data: {ApiKeys.email: email},
    );
  }

  Future<List<String>> getMemberPermissions(int id, String memberUserId) async {
    final data = await apiService.get(
      ApiEndpoints.memberPermissions(id, memberUserId),
    );
    return List<String>.from(data[ApiKeys.permissions] ?? []);
  }

  Future<void> updateMemberPermissions(
      int id,
      String memberUserId,
      List<String> permissions,
      ) async {
    await apiService.put(
      ApiEndpoints.memberPermissions(id, memberUserId),
      data: {ApiKeys.permissions: permissions},
    );
  }
}