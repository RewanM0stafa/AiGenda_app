import '../../domain/subtask_repository.dart';
import '../data_source/subtask_remote_data_source.dart';

class SubTaskRepositoryImpl implements SubTaskRepository {
  final SubTaskRemoteDataSource remote;

  SubTaskRepositoryImpl(this.remote);

  @override
  Future<void> createSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String title,
  }) => remote.createSubTask(
    workspaceId: workspaceId,
    spaceId: spaceId,
    taskId: taskId,
    title: title,
  );

  @override
  Future<void> updateSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
    required String title,
  }) => remote.updateSubTask(
    workspaceId: workspaceId,
    spaceId: spaceId,
    taskId: taskId,
    subTaskId: subTaskId,
    title: title,
  );

  @override
  Future<void> deleteSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
  }) => remote.deleteSubTask(
    workspaceId: workspaceId,
    spaceId: spaceId,
    taskId: taskId,
    subTaskId: subTaskId,
  );

  @override
  Future<void> updateSubTaskStatus({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
    required bool isCompleted,
  }) => remote.updateSubTaskStatus(
    workspaceId: workspaceId,
    spaceId: spaceId,
    taskId: taskId,
    subTaskId: subTaskId,
    isCompleted: isCompleted,
  );
}