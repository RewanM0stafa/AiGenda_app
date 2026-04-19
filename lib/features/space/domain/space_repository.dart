import '../../../core/models/filter_request.dart';
import '../../../core/models/paginated_response.dart';
import '../../roles/utils/role_permissions_mapper.dart';
import '../data/models/space_model.dart';

abstract class SpaceRepository {
  Future<PaginatedResponse<SpaceModel>> getSpaces(
      int workspaceId, {
        FilterRequest filter = const FilterRequest(),
      });
  Future<List<SpaceModel>> getDeletedSpaces(int workspaceId);

  Future<SpaceModel> getSpaceById(int workspaceId, String spaceId);

  Future<void> createSpace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required bool isPublic,
  });

  Future<void> updateSpace({
    required int workspaceId,
    required String spaceId,
    required String name,
    required String description,
    required String iconCode,
    required bool isPublic,
  });

  Future<void> deleteSpace(int workspaceId, String spaceId);

  Future<void> moveSpace({
    required int workspaceId,
    required String spaceId,
    required int targetWorkspaceId,
  });

  Future<void> restoreSpace(int workspaceId, String spaceId);
}