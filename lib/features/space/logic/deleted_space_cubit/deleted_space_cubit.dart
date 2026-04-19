import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/space_repository.dart';
import 'deleted_space_state.dart';

class DeletedSpaceCubit extends Cubit<DeletedSpaceState> {
  final SpaceRepository repository;

  DeletedSpaceCubit(this.repository) : super(DeletedSpaceInitial());

  Future<void> getDeletedSpaces(int workspaceId) async {
    try {
      emit(DeletedSpaceLoading());
      final spaces = await repository.getDeletedSpaces(workspaceId);
      emit(DeletedSpacesSuccess(spaces));
    } catch (e) {
      emit(DeletedSpaceError(e.toString()));
    }
  }

  Future<void> restoreSpace(int workspaceId, String spaceId) async {
    try {
      emit(DeletedSpaceLoading());
      await repository.restoreSpace(workspaceId, spaceId);
      await getDeletedSpaces(workspaceId);
    } catch (e) {
      emit(DeletedSpaceError(e.toString()));
    }
  }
}