import '../../../../core/models/filter_request.dart';
import '../../../../core/models/paginated_response.dart';
import '../../domain/task_repository.dart';
import '../data_source/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;

  TaskRepositoryImpl(this.remote);

  @override
  Future<PaginatedResponse<TaskModel>> getTasks(int workspaceId, String spaceId ,{
  FilterRequest filter = const FilterRequest(),
  }) =>
      remote.getTasks(workspaceId, spaceId);

  @override
  Future<TaskModel> getTaskById(
      int workspaceId,
      String spaceId,
      String taskId,
      ) => remote.getTaskById(workspaceId, spaceId, taskId);

  @override
  Future<void> createTask({
    required int workspaceId,
    required String spaceId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  }) => remote.createTask(
    workspaceId: workspaceId,
    spaceId: spaceId,
    title: title,
    description: description,
    priority: priority,
    dueDate: dueDate,
  );

  @override
  Future<void> updateTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  }) => remote.updateTask(
    workspaceId: workspaceId,
    spaceId: spaceId,
    taskId: taskId,
    title: title,
    description: description,
    priority: priority,
    dueDate: dueDate,
  );

  @override
  Future<void> deleteTask(int workspaceId, String spaceId, String taskId) =>
      remote.deleteTask(workspaceId, spaceId, taskId);

  @override
  Future<void> updateTaskStatus({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required int status,
  }) => remote.updateTaskStatus(
    workspaceId: workspaceId,
    spaceId: spaceId,
    taskId: taskId,
    status: status,
  );

  @override
  Future<void> restoreTask(int workspaceId, String spaceId, String taskId) =>
      remote.restoreTask(workspaceId, spaceId, taskId);

  @override
  Future<void> assignTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String email,
  }) => remote.assignTask(
    workspaceId: workspaceId,
    spaceId: spaceId,
    taskId: taskId,
    email: email,
  );

  @override
  Future<void> unassignTask({
    required int workspaceId,
    required String spaceId,
    required String taskId,
    required String email,
  }) => remote.unassignTask(
    workspaceId: workspaceId,
    spaceId: spaceId,
    taskId: taskId,
    email: email,
  );
}