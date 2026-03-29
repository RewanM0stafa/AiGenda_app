
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/workspace_repository.dart';
import 'member_state.dart';

class MembersCubit extends Cubit<MembersState> {
  final WorkspaceRepository repository;

  MembersCubit(this.repository) : super(MembersInitial());

  //  GET MEMBERS
  Future<void> getMembers(int workspaceId) async {
    try {
      emit(MembersLoading());

      final members = await repository.getMembers(workspaceId);

      emit(MembersSuccess(members));
    } catch (e) {
      emit(MembersError(_handleError(e)));
    }
  }

  //  ADD MEMBER
  Future<void> addMember(int workspaceId, String email) async {
    try {
      emit(MembersLoading());

      await repository.addMember(workspaceId, email);

      await getMembers(workspaceId);
    } catch (e) {
      emit(MembersError(_handleError(e)));
    }
  }

  //  ERROR HANDLER
  String _handleError(dynamic error) {
    return error.toString();
  }
}