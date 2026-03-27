import 'package:ajenda_app/core/network/api_keys.dart';

import '../../../../core/network/api_endpoints.dart';

class ProfileModel {
  final String id;
  final String firstName;
  final String secondName;
  final String email;
  final String? jobTitle;
  final String? dateOfBirth;
  final String? profileImage;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.email,
    this.jobTitle,
    this.dateOfBirth,
    this.profileImage,
  });

  String get fullName => '$firstName $secondName';
  String get displayName => '@$firstName$secondName';

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String? avatarPath = json[ApiKeys.avatarUrl] ?? json['avatar'];

    // ✅ معالجة الرابط: لو موجود ومش بيبدأ بـ http، ندمجه مع الـ baseUrl
    if (avatarPath != null && !avatarPath.startsWith('http')) {
      avatarPath = '${ApiEndpoints.baseUrl}$avatarPath';
    }

    return ProfileModel(
      id: json[ApiKeys.id] ?? '',
      firstName: json[ApiKeys.firstName] ?? '',
      secondName: json[ApiKeys.secondName] ?? '',
      email: json[ApiKeys.email] ?? '',
      jobTitle: json[ApiKeys.jobTitle],
      dateOfBirth: json[ApiKeys.dateOfBirth],
      profileImage: avatarPath,
    );
  }
  Map<String, dynamic> toJson() => {
    ApiKeys.id: id,
    ApiKeys.firstName: firstName,
    ApiKeys.secondName: secondName,
    ApiKeys.email: email,
    if (jobTitle != null) ApiKeys.jobTitle: jobTitle,
    if (dateOfBirth != null) ApiKeys.dateOfBirth: dateOfBirth,
    if (profileImage != null) ApiKeys.avatarUrl: profileImage,
  };

  ProfileModel copyWith({
    String? firstName,
    String? secondName,
    String? jobTitle,
    String? dateOfBirth,
    String? profileImage,
  }) =>
      ProfileModel(
        id: id,
        firstName: firstName ?? this.firstName,
        secondName: secondName ?? this.secondName,
        email: email,
        jobTitle: jobTitle ?? this.jobTitle,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        profileImage: profileImage ?? this.profileImage,
      );
}