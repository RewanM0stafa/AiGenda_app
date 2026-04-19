import '../../data/models/space_model.dart';

abstract class DeletedSpaceState {}

class DeletedSpaceInitial extends DeletedSpaceState {}

class DeletedSpaceLoading extends DeletedSpaceState {}

class DeletedSpacesSuccess extends DeletedSpaceState {
  final List<SpaceModel> spaces;
  DeletedSpacesSuccess(this.spaces);
}

class DeletedSpaceError extends DeletedSpaceState {
  final String message;
  DeletedSpaceError(this.message);
}