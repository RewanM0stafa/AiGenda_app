import 'package:ajenda_app/core/network/api_keys.dart';

class ConfirmEmailRequest {
  final String userId;
  final String code;

  ConfirmEmailRequest({required this.userId, required this.code});

  Map<String, dynamic> toJson() => {
    ApiKeys.userId: userId.trim(),
    ApiKeys.code: code.replaceAll(RegExp(r'\s+'), '').trim(),
  };
}






/*
class ConfirmEmailRequest {
  final String userId;
  final String code;

  ConfirmEmailRequest({required this.userId, required this.code});

  Map<String, dynamic> toJson() => {
    ApiKeys.userId: userId, //  "userId" للـ request هنحتاج
    ApiKeys.code: code,
  };
}

 */