import '../../data/models/member_model.dart';

abstract class MembersState {}

class MembersInitial extends MembersState {}

class MembersLoading extends MembersState {}

class MembersSuccess extends MembersState {
  final List<MemberModel> members;

  MembersSuccess(this.members);
}

class MembersError extends MembersState {
  final String message;

  MembersError(this.message);
}
