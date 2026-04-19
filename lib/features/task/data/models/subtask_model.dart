import '../../../../core/network/api_keys.dart';

class SubTaskModel {
  final String id;
  final String title;
  final bool isCompleted;

  SubTaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      id: json[ApiKeys.id].toString(),
      title: json[ApiKeys.title],
      isCompleted: json[ApiKeys.isCompleted] ?? false,
    );
  }
}
