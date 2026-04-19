import '../../../../core/models/filter_request.dart';
import '../../../../core/models/paginated_response.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_keys.dart';
import '../../../../core/network/api_service.dart';
import '../models/space_model.dart';

class SpaceRemoteDataSource {
  final ApiService apiService;

  SpaceRemoteDataSource(this.apiService);

  Future<PaginatedResponse<SpaceModel>> getSpaces(
      int workspaceId, {
        FilterRequest filter = const FilterRequest(),
      }) async {
    final data = await apiService.get(
      ApiEndpoints.spaces(workspaceId),
      queryParameters: filter.toQueryParams(),
    );
    return PaginatedResponse.fromJson(data, SpaceModel.fromJson);
  }

  Future<SpaceModel> getSpaceById(int workspaceId, String spaceId) async {
    final data = await apiService.get(
      ApiEndpoints.spaceById(workspaceId, spaceId),
    );
    return SpaceModel.fromJson(data);
  }

  Future<List<SpaceModel>> getDeletedSpaces(int workspaceId) async {
    final data = await apiService.get(
      ApiEndpoints.deletedSpaces(workspaceId),
    );
    return (data as List).map((e) => SpaceModel.fromJson(e)).toList();
  }

  Future<void> createSpace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required bool isPublic,
  }) async {
    await apiService.post(
      ApiEndpoints.spaces(workspaceId),
      data: {
        ApiKeys.name: name,
        ApiKeys.description: description,
        ApiKeys.iconCode: iconCode,
        ApiKeys.isPublic: isPublic,
      },
    );
  }

  Future<void> updateSpace({
    required int workspaceId,
    required String spaceId,
    required String name,
    required String description,
    required String iconCode,
    required bool isPublic,
  }) async {
    await apiService.put(
      ApiEndpoints.spaceById(workspaceId, spaceId),
      data: {
        ApiKeys.name: name,
        ApiKeys.description: description,
        ApiKeys.iconCode: iconCode,
        ApiKeys.isPublic: isPublic,
      },
    );
  }

  Future<void> deleteSpace(int workspaceId, String spaceId) async {
    await apiService.delete(ApiEndpoints.spaceById(workspaceId, spaceId));
  }

  Future<void> moveSpace({
    required int workspaceId,
    required String spaceId,
    required int targetWorkspaceId,
  }) async {
    await apiService.put(
      ApiEndpoints.moveSpace(workspaceId, spaceId),
      data: {ApiKeys.targetWorkspaceId: targetWorkspaceId},
    );
  }

  Future<void> restoreSpace(int workspaceId, String spaceId) async {
    await apiService.put(ApiEndpoints.restoreSpace(workspaceId, spaceId));
  }
}