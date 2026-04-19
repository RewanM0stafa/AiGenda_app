// features/workspace/data/models/workspace_dashboard_model.dart
import '../../../../core/network/api_keys.dart';

class WorkspaceDashboardModel {
  final int totalSpaces;
  final int totalTasks;
  final int totalMembers;
  final int completedTasks;
  final int inProgressTasks;
  final int todoTasks;

  WorkspaceDashboardModel({
    required this.totalSpaces,
    required this.totalTasks,
    required this.totalMembers,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.todoTasks,
  });

  factory WorkspaceDashboardModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceDashboardModel(
      totalSpaces: json[ApiKeys.totalSpaces] ?? 0,
      totalTasks: json[ApiKeys.totalTasks] ?? 0,
      totalMembers: json[ApiKeys.totalMembers] ?? 0,
      completedTasks: json[ApiKeys.completedTasks] ?? 0,
      inProgressTasks: json[ApiKeys.inProgressTasks] ?? 0,
      todoTasks: json[ApiKeys.todoTasks] ?? 0,
    );
  }
}

