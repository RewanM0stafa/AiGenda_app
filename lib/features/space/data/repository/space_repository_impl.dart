import '../../../../core/models/filter_request.dart';
import '../../../../core/models/paginated_response.dart';
import '../../../roles/utils/role_permissions_mapper.dart';
import '../../domain/space_repository.dart';
import '../data_source/space_remote_data_source.dart';
import '../models/space_model.dart';

class SpaceRepositoryImpl implements SpaceRepository {
  final SpaceRemoteDataSource remote;

  SpaceRepositoryImpl(this.remote);

  @override
  Future<PaginatedResponse<SpaceModel>> getSpaces(int workspaceId,{
  FilterRequest filter = const FilterRequest(),
  }) =>
      remote.getSpaces(workspaceId);

  @override
  Future<List<SpaceModel>> getDeletedSpaces(int workspaceId) =>
      remote.getDeletedSpaces(workspaceId);

  @override
  Future<SpaceModel> getSpaceById(int workspaceId, String spaceId) =>
      remote.getSpaceById(workspaceId, spaceId);

  @override
  Future<void> createSpace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required bool isPublic,
  }) =>
      remote.createSpace(
        workspaceId: workspaceId,
        name: name,
        description: description,
        iconCode: iconCode,
        isPublic: isPublic,
      );

  @override
  Future<void> updateSpace({
    required int workspaceId,
    required String spaceId,
    required String name,
    required String description,
    required String iconCode,
    required bool isPublic,
  }) =>
      remote.updateSpace(
        workspaceId: workspaceId,
        spaceId: spaceId,
        name: name,
        description: description,
        iconCode: iconCode,
        isPublic: isPublic,
      );

  @override
  Future<void> deleteSpace(int workspaceId, String spaceId) =>
      remote.deleteSpace(workspaceId, spaceId);

  @override
  Future<void> moveSpace({
    required int workspaceId,
    required String spaceId,
    required int targetWorkspaceId,
  }) =>
      remote.moveSpace(
        workspaceId: workspaceId,
        spaceId: spaceId,
        targetWorkspaceId: targetWorkspaceId,
      );

  @override
  Future<void> restoreSpace(int workspaceId, String spaceId) =>
      remote.restoreSpace(workspaceId, spaceId);
}