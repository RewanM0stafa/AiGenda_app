// 1) اليوزر هيكتب بياناته ف ال client UI
// 2)المودل دا هو المترجم اللي بيستقبل ال object data دي ويحوللها ل (map -> dio -> json)
/* مودل استقبال الداتا الأجنبية من جهة السرفر  request model*/
/* toJson factory */


import '../../../../../core/network/api_keys.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    ApiKeys.email: email.trim().toLowerCase(),
    ApiKeys.password: password,
  };
}
