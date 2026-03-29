import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_keys.dart';
import '../models/member_model.dart';
import '../models/workspace_model.dart';

class WorkspaceRemoteDataSource {
  final Dio dio;

  WorkspaceRemoteDataSource(this.dio);

  Future<List<WorkspaceModel>> getWorkspaces() async {
    final response = await dio.get(ApiEndpoints.workspaces);

    return (response.data as List)
        .map((e) => WorkspaceModel.fromJson(e))
        .toList();
  }

  Future<void> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    await dio.post(
      ApiEndpoints.workspaces,
      data: {
        ApiKeys.name: name,
        ApiKeys.description: description,
        ApiKeys.iconCode: iconCode,
        ApiKeys.visibility: visibility,
      },
    );
  }

  Future<List<MemberModel>> getMembers(int workspaceId) async {
    final response =
    await dio.get(ApiEndpoints.members(workspaceId));

    return (response.data as List)
        .map((e) => MemberModel.fromJson(e))
        .toList();
  }

  Future<void> addMember(int workspaceId, String email) async {
    await dio.post(
      ApiEndpoints.addMember(workspaceId),
      data: {ApiKeys.email: email},
    );
  }

  Future<void> updatePermissions(
      int workspaceId,
      String userId,
      List<String> permissions,
      ) async {
    await dio.put(
      ApiEndpoints.updatePermissions(workspaceId, userId),
      data: {ApiKeys.permissions: permissions},
    );
  }
}