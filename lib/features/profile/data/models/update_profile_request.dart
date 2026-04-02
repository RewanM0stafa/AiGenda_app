import '../../../../core/network/api_keys.dart';

class UpdateProfileRequest {
  final String firstName;
  final String secondName;
  final String? jobTitle;
  final String dateOfBirth;

  UpdateProfileRequest({
    required this.firstName,
    required this.secondName,
    this.jobTitle,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.firstName: firstName,
      ApiKeys.secondName: secondName,
      ApiKeys.dateOfBirth: dateOfBirth,
      if (jobTitle != null) ApiKeys.jobTitle: jobTitle,
      //if (dateOfBirth != null) ApiKeys.dateOfBirth: dateOfBirth,
    };
  }
}