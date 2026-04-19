import '../../../../core/network/api_keys.dart';
import '../../enums/task_priority.dart';
import '../../enums/task_status.dart';
import 'subtask_model.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final String spaceId;
  final int workspaceId;
  final List<String> assignees;
  final List<SubTaskModel> subTasks;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.status,
    this.dueDate,
    required this.spaceId,
    required this.workspaceId,
    this.assignees = const [],
    this.subTasks = const [],
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json[ApiKeys.id].toString(),
      title: json[ApiKeys.title],
      description: json[ApiKeys.description],
      priority: TaskPriority.fromInt(json[ApiKeys.priority] ?? 0),
      status: TaskStatus.fromInt(json[ApiKeys.status] ?? 0),
      dueDate: json[ApiKeys.dueDate] != null
          ? DateTime.tryParse(json[ApiKeys.dueDate])
          : null,
      spaceId: json[ApiKeys.spaceId]?.toString() ?? '',
      workspaceId: json[ApiKeys.workspaceId] ?? 0,
      assignees: json[ApiKeys.assignees] != null
          ? List<String>.from(json[ApiKeys.assignees])
          : [],
      subTasks: json[ApiKeys.subTasks] != null
          ? (json[ApiKeys.subTasks] as List)
          .map((e) => SubTaskModel.fromJson(e))
          .toList()
          : [],
    );
  }
}