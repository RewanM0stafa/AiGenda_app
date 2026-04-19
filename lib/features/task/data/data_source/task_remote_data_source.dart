import '../../../../core/models/filter_request.dart';
import '../../../../core/models/paginated_response.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_keys.dart';
import '../../../../core/network/api_service.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final ApiService apiService;

  TaskRemoteDataSource(this.apiService);

  Future<PaginatedResponse<TaskModel>> getTasks(
      int workspaceId,
      String spaceId, {
        FilterRequest filter = const FilterRequest(),
      }) async {
    final data = await apiService.get(
      ApiEndpoints.tasks(workspaceId, spaceId),
      queryParameters: filter.toQueryParams(),
    );
    return PaginatedResponse.fromJson(data, TaskModel.fromJson);
  }

  Future<TaskModel> getTaskById(
      int workspaceId,
      String spaceId,
      String taskId,
      ) async {
    final data = await apiService.get(
      ApiEndpoints.taskById(workspaceId, spaceId, taskId),
    );
    return TaskModel.fromJson(data);
  }

  Future<void> createTask({
    required int workspaceId,
    required String spaceId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  }) async {
    await apiService.post(
      ApiEndpoints.tasks(workspaceId, spaceId),
      data: {
        ApiKeys.title: title,
        ApiKeys.description: description,
        ApiKeys.priority: priority,
        ApiKeys.dueDate: dueDate?.toIso8601String(),
      },
    );
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
    await apiService.put(
      ApiEndpoints.taskById(workspaceId, spaceId, taskId),
      data: {
        ApiKeys.title: title,
        ApiKeys.description: description,
        ApiKeys.priority: priority,
        ApiKeys.dueDate: dueDate?.toIso8601String(),
      },
    );
  }

  Future<void> deleteTask(
      int workspaceId,
      String spaceId,
      String taskId,
      ) async {
    await apiService.delete(ApiEndpoints.taskById(workspaceId, spaceId, taskId));
  }

  Future<void> updateTaskStatus({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required int status,
  }) async {
    await apiService.put(
      ApiEndpoints.taskStatus(workspaceId, spaceId, taskId),
      data: {ApiKeys.status: status},
    );
  }

  Future<void> restoreTask(
      int workspaceId,
      String spaceId,
      String taskId,
      ) async {
    await apiService.put(ApiEndpoints.taskRestore(workspaceId, spaceId, taskId));
  }

  Future<void> assignTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String email,
  }) async {
    await apiService.put(
      ApiEndpoints.taskAssign(workspaceId, spaceId, taskId),
      data: {ApiKeys.email: email},
    );
  }

  Future<void> unassignTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String email,
  }) async {
    await apiService.delete(
      ApiEndpoints.taskUnassign(workspaceId, spaceId, taskId),
      data: {ApiKeys.email: email},
    );
  }
}