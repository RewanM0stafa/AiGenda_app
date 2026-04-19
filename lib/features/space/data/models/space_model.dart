import '../../../../core/network/api_keys.dart';

class SpaceModel {
  final String id;
  final String name;
  final String? description;
  final String iconCode;
  final bool isPublic;
  final int workspaceId;

  SpaceModel({
    required this.id,
    required this.name,
    this.description,
    required this.iconCode,
    required this.isPublic,
    required this.workspaceId,
  });

  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: json[ApiKeys.id].toString(),
      name: json[ApiKeys.name],
      description: json[ApiKeys.description],
      iconCode: json[ApiKeys.iconCode],
      isPublic: json[ApiKeys.isPublic] ?? false,
      workspaceId: json[ApiKeys.workspaceId],
    );
  }
}