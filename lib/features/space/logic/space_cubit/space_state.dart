import '../../../../core/models/paginated_response.dart';
import '../../../roles/utils/role_permissions_mapper.dart';
import '../../data/models/space_model.dart';

abstract class SpaceState {}

class SpaceInitial extends SpaceState {}

class SpaceLoading extends SpaceState {}

class SpacesSuccess extends SpaceState {
  final PaginatedResponse<SpaceModel> data;
  SpacesSuccess(this.data);
}

class SpaceDetailSuccess extends SpaceState {
  final SpaceModel space;
  SpaceDetailSuccess(this.space);
}

class SpaceActionSuccess extends SpaceState {}

class SpaceError extends SpaceState {
  final String message;
  SpaceError(this.message);
}