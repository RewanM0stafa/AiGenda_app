import '../../domain/workspace_repository.dart';
import '../data_source/workspace_remote_data_source.dart';
import '../models/member_model.dart';
import '../models/workspace_model.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remote;

  WorkspaceRepositoryImpl(this.remote);

  @override
  Future<List<WorkspaceModel>> getWorkspaces() {
    return remote.getWorkspaces();
  }

  @override
  Future<void> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) {
    return remote.createWorkspace(
      name: name,
      description: description,
      iconCode: iconCode,
      visibility: visibility,
    );
  }

  @override
  Future<List<MemberModel>> getMembers(int workspaceId) {
    return remote.getMembers(workspaceId);
  }

  @override
  Future<void> addMember(int workspaceId, String email) {
    return remote.addMember(workspaceId, email);
  }

  @override
  Future<void> updatePermissions(
      int workspaceId,
      String userId,
      List<String> permissions) {
    return remote.updatePermissions(
      workspaceId,
      userId,
      permissions,
    );
  }
}