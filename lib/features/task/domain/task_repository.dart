import '../../../core/models/filter_request.dart';
import '../../../core/models/paginated_response.dart';
import '../data/models/task_model.dart';

abstract class TaskRepository {
  Future<PaginatedResponse<TaskModel>> getTasks(
    int workspaceId,
    String spaceId, {
    FilterRequest filter = const FilterRequest(),
  });
  Future<TaskModel> getTaskById(int workspaceId, String spaceId, String taskId);

  Future<void> createTask({
    required int workspaceId,
    required String spaceId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  });

  Future<void> updateTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  });

  Future<void> deleteTask(int workspaceId, String spaceId, String taskId);

  Future<void> updateTaskStatus({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required int status,
  });

  Future<void> restoreTask(int workspaceId, String spaceId, String taskId);

  Future<void> assignTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String email,
  });

  Future<void> unassignTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String email,
  });
}
