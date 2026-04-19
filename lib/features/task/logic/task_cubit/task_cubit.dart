import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/filter_request.dart';
import '../../domain/task_repository.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository repository;

  TaskCubit(this.repository) : super(TaskInitial());

  Future<void> getTasks(
      int workspaceId,
      String spaceId, {
        FilterRequest filter = const FilterRequest(),
      }) async {
    try {
      emit(TaskLoading());
      final result = await repository.getTasks(workspaceId, spaceId, filter: filter);
      emit(TasksSuccess(result));
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  Future<void> getTaskById(
    int workspaceId,
    String spaceId,
    String taskId,
  ) async {
    try {
      emit(TaskLoading());
      final task = await repository.getTaskById(workspaceId, spaceId, taskId);
      emit(TaskDetailSuccess(task));
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  Future<void> createTask({
    required int workspaceId,
    required String spaceId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  }) async {
    try {
      emit(TaskLoading());
      await repository.createTask(
        workspaceId: workspaceId,
        spaceId: spaceId,
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
      );
      await getTasks(workspaceId, spaceId);
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  Future<void> updateTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  }) async {
    try {
      emit(TaskLoading());
      await repository.updateTask(
        workspaceId: workspaceId,
        spaceId: spaceId,
        taskId: taskId,
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
      );
      await getTasks(workspaceId, spaceId);
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  Future<void> deleteTask(
    int workspaceId,
    String spaceId,
    String taskId,
  ) async {
    try {
      emit(TaskLoading());
      await repository.deleteTask(workspaceId, spaceId, taskId);
      await getTasks(workspaceId, spaceId);
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  Future<void> updateTaskStatus({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required int status,
  }) async {
    try {
      emit(TaskLoading());
      await repository.updateTaskStatus(
        workspaceId: workspaceId,
        spaceId: spaceId,
        taskId: taskId,
        status: status,
      );
      await getTasks(workspaceId, spaceId);
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  Future<void> restoreTask(
    int workspaceId,
    String spaceId,
    String taskId,
  ) async {
    try {
      emit(TaskLoading());
      await repository.restoreTask(workspaceId, spaceId, taskId);
      await getTasks(workspaceId, spaceId);
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  Future<void> assignTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String email,
  }) async {
    try {
      emit(TaskLoading());
      await repository.assignTask(
        workspaceId: workspaceId,
        spaceId: spaceId,
        taskId: taskId,
        email: email,
      );
      await getTasks(workspaceId, spaceId);
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  Future<void> unassignTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String email,
  }) async {
    try {
      emit(TaskLoading());
      await repository.unassignTask(
        workspaceId: workspaceId,
        spaceId: spaceId,
        taskId: taskId,
        email: email,
      );
      await getTasks(workspaceId, spaceId);
    } catch (e) {
      emit(TaskError(_handleError(e)));
    }
  }

  String _handleError(dynamic error) => error.toString();
}
