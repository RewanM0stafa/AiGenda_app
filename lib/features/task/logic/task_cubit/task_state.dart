import '../../../../core/models/paginated_response.dart';
import '../../data/models/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksSuccess extends TaskState {
  final PaginatedResponse<TaskModel> data;
  TasksSuccess(this.data);
}

class TaskDetailSuccess extends TaskState {
  final TaskModel task;
  TaskDetailSuccess(this.task);
}

class TaskActionSuccess extends TaskState {}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
