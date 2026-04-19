import '../../../../core/network/api_keys.dart';

class WorkspaceModel {
  final int id;
  final String name;
  final String description;
  final String iconCode;
  final int visibility;
  final int numberOfMembers;
  final int numberOfTasks;
  final bool isOwnedByCurrentUser;

  WorkspaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconCode,
    required this.visibility,
    required this.numberOfMembers,
    required this.numberOfTasks,
    required this.isOwnedByCurrentUser,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      description: json[ApiKeys.description] ?? '',
      iconCode: json[ApiKeys.iconCode] ?? '',
      visibility: json[ApiKeys.visibility] ?? 0,
      numberOfMembers: json[ApiKeys.numberOfMembers] ?? 0,
      numberOfTasks: json[ApiKeys.numberOfTasks] ?? 0,
      isOwnedByCurrentUser: json[ApiKeys.isOwnedByCurrentUser] ?? false,
    );
  }
}