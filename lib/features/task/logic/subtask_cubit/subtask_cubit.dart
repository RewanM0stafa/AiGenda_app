import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/subtask_repository.dart';
import '../task_cubit/task_cubit.dart';
import 'subtask_state.dart';

class SubTaskCubit extends Cubit<SubTaskState> {
  final SubTaskRepository repository;
  final TaskCubit taskCubit;

  SubTaskCubit(this.repository, this.taskCubit) : super(SubTaskInitial());

  Future<void> createSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String title,
  }) async {
    try {
      emit(SubTaskLoading());
      await repository.createSubTask(
        workspaceId: workspaceId,
        spaceId: spaceId,
        taskId: taskId,
        title: title,
      );
      emit(SubTaskActionSuccess());
      await taskCubit.getTaskById(workspaceId, spaceId, taskId);
    } catch (e) {
      emit(SubTaskError(e.toString()));
    }
  }

  Future<void> updateSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
    required String title,
  }) async {
    try {
      emit(SubTaskLoading());
      await repository.updateSubTask(
        workspaceId: workspaceId,
        spaceId: spaceId,
        taskId: taskId,
        subTaskId: subTaskId,
        title: title,
      );
      emit(SubTaskActionSuccess());
      await taskCubit.getTaskById(workspaceId, spaceId, taskId);
    } catch (e) {
      emit(SubTaskError(e.toString()));
    }
  }

  Future<void> deleteSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
  }) async {
    try {
      emit(SubTaskLoading());
      await repository.deleteSubTask(
        workspaceId: workspaceId,
        spaceId: spaceId,
        taskId: taskId,
        subTaskId: subTaskId,
      );
      emit(SubTaskActionSuccess());
      await taskCubit.getTaskById(workspaceId, spaceId, taskId);
    } catch (e) {
      emit(SubTaskError(e.toString()));
    }
  }

  Future<void> updateSubTaskStatus({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
    required bool isCompleted,
  }) async {
    try {
      emit(SubTaskLoading());
      await repository.updateSubTaskStatus(
        workspaceId: workspaceId,
        spaceId: spaceId,
        taskId: taskId,
        subTaskId: subTaskId,
        isCompleted: isCompleted,
      );
      emit(SubTaskActionSuccess());
      await taskCubit.getTaskById(workspaceId, spaceId, taskId);
    } catch (e) {
      emit(SubTaskError(e.toString()));
    }
  }
}