// workspace_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_keys.dart';
import '../models/member_model.dart';
import '../models/workspace_model.dart';

class WorkspaceRemoteDataSource {
  final Dio dio;
  WorkspaceRemoteDataSource(this.dio);

  Future<List<WorkspaceModel>> getWorkspaces() async {
    final r = await dio.get(ApiEndpoints.workspaces);
    return (r.data as List).map((e) => WorkspaceModel.fromJson(e)).toList();
  }

  Future<int?> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    final r = await dio.post(ApiEndpoints.workspaces, data: {
      ApiKeys.name: name,
      ApiKeys.description: description,
      ApiKeys.iconCode: iconCode,
      ApiKeys.visibility: visibility,
    });
    if (r.data is Map) return r.data['id'] as int?;
    return null;
  }

  // ✅ Edit — PUT /api/WorkSpaces/{id}
  Future<void> editWorkspace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    await dio.put(ApiEndpoints.editWorkspace(workspaceId), data: {
      ApiKeys.name: name,
      ApiKeys.description: description,
      ApiKeys.iconCode: iconCode,
      ApiKeys.visibility: visibility,
    });
  }

  Future<void> deleteWorkspace(int id) async =>
      await dio.delete(ApiEndpoints.workspaceById(id));

  Future<void> leaveWorkspace(int id) async =>
      await dio.delete(ApiEndpoints.leaveWorkspace(id));

  Future<List<MemberModel>> getMembers(int id) async {
    final r = await dio.get(ApiEndpoints.members(id));
    return (r.data as List).map((e) => MemberModel.fromJson(e)).toList();
  }

  Future<void> addMember(int id, String email) async =>
      await dio.post(ApiEndpoints.addMember(id), data: {ApiKeys.email: email});

  Future<void> updatePermissions(
    int id,
    String userId,
    List<String> permissions,
  ) async =>
      await dio.put(ApiEndpoints.updatePermissions(id, userId),
          data: {ApiKeys.permissions: permissions});
}