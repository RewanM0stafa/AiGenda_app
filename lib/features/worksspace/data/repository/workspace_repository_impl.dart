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
        name: name, description: description,
        iconCode: iconCode, visibility: visibility);

  @override
  Future<void> editWorkspace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) => remote.editWorkspace(
        workspaceId: workspaceId, name: name,
        description: description, iconCode: iconCode, visibility: visibility);

  @override
  Future<void> deleteWorkspace(int id) => remote.deleteWorkspace(id);

  @override
  Future<void> leaveWorkspace(int id) => remote.leaveWorkspace(id);

  @override
  Future<List<MemberModel>> getMembers(int id) => remote.getMembers(id);

  @override
  Future<void> addMember(int id, String email) => remote.addMember(id, email);

  @override
  Future<void> updatePermissions(int id, String userId, List<String> p) =>
      remote.updatePermissions(id, userId, p);
}