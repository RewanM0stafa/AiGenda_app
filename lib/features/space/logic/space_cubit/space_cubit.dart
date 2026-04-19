import 'package:ajenda_app/features/space/logic/space_cubit/space_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/filter_request.dart';
import '../../domain/space_repository.dart';

class SpaceCubit extends Cubit<SpaceState> {
  final SpaceRepository repository;

  SpaceCubit(this.repository) : super(SpaceInitial());

  Future<void> getSpaces(
      int workspaceId, {
        FilterRequest filter = const FilterRequest(),
      }) async {
    try {
      emit(SpaceLoading());
      final result = await repository.getSpaces(workspaceId, filter: filter);
      emit(SpacesSuccess(result));
    } catch (e) {
      emit(SpaceError(_handleError(e)));
    }
  }

  Future<void> getSpaceById(int workspaceId, String spaceId) async {
    try {
      emit(SpaceLoading());
      final space = await repository.getSpaceById(workspaceId, spaceId);
      emit(SpaceDetailSuccess(space));
    } catch (e) {
      emit(SpaceError(_handleError(e)));
    }
  }

  Future<void> createSpace({
    required int workspaceId,
    required String name,
    required String description,
    required String iconCode,
    required bool isPublic,
  }) async {
    try {
      emit(SpaceLoading());
      await repository.createSpace(
        workspaceId: workspaceId,
        name: name,
        description: description,
        iconCode: iconCode,
        isPublic: isPublic,
      );
      await getSpaces(workspaceId);
    } catch (e) {
      emit(SpaceError(_handleError(e)));
    }
  }

  Future<void> updateSpace({
    required int workspaceId,
    required String spaceId,
    required String name,
    required String description,
    required String iconCode,
    required bool isPublic,
  }) async {
    try {
      emit(SpaceLoading());
      await repository.updateSpace(
        workspaceId: workspaceId,
        spaceId: spaceId,
        name: name,
        description: description,
        iconCode: iconCode,
        isPublic: isPublic,
      );
      await getSpaces(workspaceId);
    } catch (e) {
      emit(SpaceError(_handleError(e)));
    }
  }

  Future<void> deleteSpace(int workspaceId, String spaceId) async {
    try {
      emit(SpaceLoading());
      await repository.deleteSpace(workspaceId, spaceId);
      await getSpaces(workspaceId);
    } catch (e) {
      emit(SpaceError(_handleError(e)));
    }
  }

  Future<void> moveSpace({
    required int workspaceId,
    required String spaceId,
    required int targetWorkspaceId,
  }) async {
    try {
      emit(SpaceLoading());
      await repository.moveSpace(
        workspaceId: workspaceId,
        spaceId: spaceId,
        targetWorkspaceId: targetWorkspaceId,
      );
      emit(SpaceActionSuccess());
    } catch (e) {
      emit(SpaceError(_handleError(e)));
    }
  }

  String _handleError(dynamic error) => error.toString();
}