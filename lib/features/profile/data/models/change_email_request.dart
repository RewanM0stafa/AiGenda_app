


import '../../../../core/network/api_keys.dart';

class ChangeEmailRequest {
  final String newEmail;

  ChangeEmailRequest({required this.newEmail});

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.newEmail: newEmail,
    };
  }
}