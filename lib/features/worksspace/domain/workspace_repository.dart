import '../data/models/member_model.dart';
import '../data/models/workspace_model.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceModel>> getWorkspaces();

  Future<void> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  });

  Future<List<MemberModel>> getMembers(int workspaceId);

  Future<void> addMember(int workspaceId, String email);

  Future<void> updatePermissions(
      int workspaceId,
      String userId,
      List<String> permissions,
      );
}