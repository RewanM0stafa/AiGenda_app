import '../../../../core/network/api_keys.dart';

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.currentPassword: currentPassword,
      ApiKeys.newPassword: newPassword,
    };
  }
}