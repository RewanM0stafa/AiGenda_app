import '../../../../core/network/api_keys.dart';

class MemberModel {
  final String userId;
  final String fullName;
  final String email;
  final bool isOwner;
  final DateTime joinedAt;
  final List<String> permissions;

  MemberModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.isOwner,
    required this.joinedAt,
    required this.permissions,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      userId: json[ApiKeys.userId],
      fullName: json[ApiKeys.fullName],
      email: json[ApiKeys.email],
      isOwner: json[ApiKeys.isOwner],
      joinedAt: DateTime.parse(json[ApiKeys.joinedAt]),
      permissions: List<String>.from(json[ApiKeys.permissions]),
    );
  }
}