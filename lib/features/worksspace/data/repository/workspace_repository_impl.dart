// data/repositories/workspace_repository_impl.dart

import '../../domain/workspace_repository.dart';
import '../data_source/workspace_remote_data_source.dart';
import '../models/member_model.dart';
import '../models/workspace_model.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remote;
  WorkspaceRepositoryImpl(this.remote);

  @override
  Future<List<WorkspaceModel>> getWorkspaces() => remote.getWorkspaces();

  @override
  Future<int?> createWorkspace({
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
  Future<void> editWorkspace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) => remote.editWorkspace(
        workspaceId: workspaceId,
        name: name,
        description: description,
        iconCode: iconCode,
        visibility: visibility,
      );

  @override
  Future<void> deleteWorkspace(int workspaceId) =>
      remote.deleteWorkspace(workspaceId);

  @override
  Future<void> leaveWorkspace(int workspaceId, String email) =>
      remote.leaveWorkspace(workspaceId, email);

  @override
  Future<List<MemberModel>> getMembers(int workspaceId) =>
      remote.getMembers(workspaceId);

  @override
  Future<void> addMember(
    int workspaceId, 
    String email,
    List<String> permissions) =>
      remote.addMember(workspaceId, email, permissions);

  @override
  Future<void> updatePermissions(
    int workspaceId,
    String userId,
    List<String> permissions,
  ) => remote.updatePermissions(workspaceId, userId, permissions);
}
