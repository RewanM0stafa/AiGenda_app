import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_keys.dart';
import '../../../../core/network/api_service.dart';

class SubTaskRemoteDataSource {
  final ApiService apiService;

  SubTaskRemoteDataSource(this.apiService);

  Future<void> createSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String title,
  }) async {
    await apiService.post(
      ApiEndpoints.subTasks(workspaceId, spaceId, taskId),
      data: {ApiKeys.title: title},
    );
  }

  Future<void> updateSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
    required String title,
  }) async {
    await apiService.put(
      ApiEndpoints.subTaskById(workspaceId, spaceId, taskId, subTaskId),
      data: {ApiKeys.title: title},
    );
  }

  Future<void> deleteSubTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
  }) async {
    await apiService.delete(
      ApiEndpoints.subTaskById(workspaceId, spaceId, taskId, subTaskId),
    );
  }

  Future<void> updateSubTaskStatus({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String subTaskId,
    required bool isCompleted,
  }) async {
    await apiService.put(
      ApiEndpoints.subTaskStatus(workspaceId, spaceId, taskId, subTaskId),
      data: {ApiKeys.isCompleted: isCompleted},
    );
  }
}