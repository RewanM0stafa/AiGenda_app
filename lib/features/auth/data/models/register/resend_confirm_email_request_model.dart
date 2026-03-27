import 'package:ajenda_app/core/network/api_keys.dart';

class ResendConfirmEmailRequest {
  final String email;
  ResendConfirmEmailRequest({required this.email});
  Map<String, dynamic> toJson() => {ApiKeys.email: email.trim().toLowerCase()};
}
/*
class ResendConfirmEmailRequest {
  final String email;
  ResendConfirmEmailRequest({required this.email});
  Map<String, dynamic> toJson() => {ApiKeys.email: email};
}*/