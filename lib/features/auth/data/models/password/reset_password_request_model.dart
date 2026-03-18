import 'package:ajenda_app/core/network/api_keys.dart';

class ResetPasswordRequest {
  final String email;
  final String code;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    ApiKeys.email: email,
    ApiKeys.code: code,  // deep link
    ApiKeys.newPassword: newPassword,
  };
}