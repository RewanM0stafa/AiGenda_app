// 1) السرفر بيبعت الداتا اللي هيطلبها اليوزر ف شكل json
// 2)المودل دا هو المترجم اللي بياخد ال json data سحوللها ل object data
/* مودل استقبال الداتا الأجنبية من جهة الكلاينت  request model*/
/* fromJson factory */


import 'package:ajenda_app/core/network/api_keys.dart';

class LoginResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;
  final String refreshToken;
  final int expiredIn;
  final String expiryDate;

  LoginResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token,
    required this.refreshToken,
    required this.expiredIn,
    required this.expiryDate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json[ApiKeys.id] ?? '',
      firstName: json[ApiKeys.firstName] ?? '',
      lastName: json[ApiKeys.lastName] ?? '',
      email: json[ApiKeys.email] ?? '',
      token: json[ApiKeys.token] ?? '',
      refreshToken: json[ApiKeys.refreshToken] ?? '',
      expiredIn: json[ApiKeys.expiredIn] ?? 0,
      expiryDate: json[ApiKeys.expiryDate] ?? '',
    );
  }
}