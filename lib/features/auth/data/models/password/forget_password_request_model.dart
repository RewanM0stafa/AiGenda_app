import 'package:ajenda_app/core/network/api_keys.dart';

class ForgetPasswordRequest {
  final String email;
  ForgetPasswordRequest({required this.email});
  Map<String, dynamic> toJson() => {ApiKeys.email: email.trim().toLowerCase()};
}