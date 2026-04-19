abstract class SubTaskRepository {
  Future<void> createSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String title,
  });

  Future<void> updateSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
    required String title,
  });

  Future<void> deleteSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
  });

  Future<void> updateSubTaskStatus({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
    required bool isCompleted,
  });
}