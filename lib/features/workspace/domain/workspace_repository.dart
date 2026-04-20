
import '../data/models/member_model.dart';
import '../data/models/workspace_model.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceModel>> getWorkspaces();

  Future<int?> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  });
// edit - PUT /api/WorkSpaces/{id}
  Future<void> editWorkspace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  });

  Future<void> deleteWorkspace(int workspaceId);
  Future<void> leaveWorkspace(int workspaceId , String email);

  Future<List<MemberModel>> getMembers(int workspaceId);

  Future<void> addMember(
    int workspaceId, 
    String email, 
    List<String> permissions);

  Future<void> updatePermissions(
    int workspaceId,
    String userId,
    List<String> permissions,
  );
}
