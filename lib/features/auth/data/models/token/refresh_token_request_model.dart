import 'package:ajenda_app/core/network/api_keys.dart';

class RefreshTokenRequest {
  final String token;
  final String refreshToken;

  RefreshTokenRequest({required this.token, required this.refreshToken});

  Map<String, dynamic> toJson() => {
    ApiKeys.token: token,
    ApiKeys.refreshToken: refreshToken,
  };
}