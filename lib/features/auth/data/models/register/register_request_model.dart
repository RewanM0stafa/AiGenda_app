import 'package:ajenda_app/core/network/api_keys.dart';

class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    ApiKeys.firstName: firstName.trim(),
    ApiKeys.lastName: lastName.trim(),
    ApiKeys.email: email.trim().toLowerCase(),
    ApiKeys.password: password,
    ApiKeys.confirmPassword: confirmPassword,
  };
}
