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
    ApiKeys.email: email.trim().toLowerCase(),
    ApiKeys.code: code.replaceAll(RegExp(r'\s+'), '').trim(),
    ApiKeys.newPassword: newPassword, // "newpassword" lowercase
  };
}



/*
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

 */