import '../../../core/models/filter_request.dart';
import '../../../core/models/paginated_response.dart';
import '../data/models/member_model.dart';
import '../data/models/workspace_dashboard_model.dart';
import '../data/models/workspace_model.dart';

abstract class WorkspaceRepository {
  //  CRUD
  Future<PaginatedResponse<WorkspaceModel>> getWorkspaces({
    FilterRequest filter = const FilterRequest(),
  });

  Future<WorkspaceModel> getWorkspaceById(int id);

  Future<void> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  });

  Future<void> updateWorkspace({
    required int id,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  });

  Future<void> deleteWorkspace(int id);

  Future<void> restoreWorkspace(int id);

  Future<List<WorkspaceModel>> getDeletedWorkspaces();

  // Dashboard
  Future<WorkspaceDashboardModel> getDashboard(int id);

  // Members
  Future<List<MemberModel>> getMembers(int id);

  Future<void> addMember(int id, String email);

  Future<void> removeMember(int id, String email);

  //  Permissions
  Future<List<String>> getMemberPermissions(int id, String memberUserId);

  Future<void> updateMemberPermissions(
      int id,
      String memberUserId,
      List<String> permissions,
      );
}