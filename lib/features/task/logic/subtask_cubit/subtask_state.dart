abstract class SubTaskState {}

class SubTaskInitial extends SubTaskState {}

class SubTaskLoading extends SubTaskState {}

class SubTaskActionSuccess extends SubTaskState {}

class SubTaskError extends SubTaskState {
  final String message;
  SubTaskError(this.message);
}
