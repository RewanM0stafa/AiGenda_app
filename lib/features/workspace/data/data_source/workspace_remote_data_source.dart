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
    if(response.data is List){
    return (response.data as List)
      .map((e) => WorkspaceModel.fromJson(e as Map<String, dynamic>))
      .toList();
  }
  if(response.data is Map){
    final map = response.data as Map<String, dynamic>;
    final list = map['data'] ?? map['items'] ?? map['workspaces'] ?? [];
    return(list as List)
      .map((e) => WorkspaceModel.fromJson(e as Map<String, dynamic>))
      .toList();
  }
  return [];
  }
  Future<int?> createWorkspace({
    required String name,
    required String description,
    required String iconCode,
    required int visibility,
  }) async {
    final response = await dio.post(
      ApiEndpoints.workspaces,
      data: {
        ApiKeys.name: name,
        ApiKeys.description: description,
        ApiKeys.iconCode: iconCode,
        ApiKeys.visibility: visibility,
      },
    );
    if(response.data is Map) return response.data['id'] as int?;
    return null;
  }

  // PUT /api/WorkSpaces/{id}
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

  Future<void> deleteWorkspace(int workspaceId) async =>
      await dio.delete(ApiEndpoints.workspaceById(workspaceId));
 
  // DELETE /api/WorkSpaces/{id}/remove -> Leave
  Future<void> leaveWorkspace(int workspaceId , String email) async =>
      await dio.delete(
        ApiEndpoints.leaveWorkspace(workspaceId),
        data: {ApiKeys.email: email},);

  Future<List<MemberModel>> getMembers(int workspaceId) async {
    final response = await dio.get(ApiEndpoints.members(workspaceId));

    return (response.data as List).map((e) => MemberModel.fromJson(e)).toList();
  }

  Future<void> addMember(
    int workspaceId, 
    String email, 
    List<String> permissions) async {
    await dio.post(
      ApiEndpoints.addMember(workspaceId),
      data: {
        ApiKeys.email: email, 
        ApiKeys.permissions: permissions,
      },
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