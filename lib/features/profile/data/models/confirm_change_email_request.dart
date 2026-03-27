import '../../../../core/network/api_keys.dart';

class ConfirmChangeEmailRequest {
  final String id;
  final String newEmail;
  final String code;

  ConfirmChangeEmailRequest({
    required this.id,
    required this.newEmail,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.confirmEmailId: id,
      ApiKeys.newEmail: newEmail,
      ApiKeys.code: code,
    };
  }
}