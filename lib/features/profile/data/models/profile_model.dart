import 'package:ajenda_app/core/network/api_keys.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/date_utils.dart';

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

  //  Getters
  String get fullName => '$firstName $secondName'.trim();
  String get displayName => '@$firstName$secondName';

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = secondName.isNotEmpty ? secondName[0] : '';
    return '$f$l'.toUpperCase();
  }

  DateTime get parsedBirthDate => AppDateUtils.safeParse(dateOfBirth);

  String get formattedBirthDate => AppDateUtils.isValid(dateOfBirth)
      ? AppDateUtils.formatForDisplay(dateOfBirth)
      : '';

  //  fromJson
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String? avatarRaw =
        json[ApiKeys.avatarUrl] ?? json['avatar'] ?? json['profileImage'];
    String? avatarUrl;
    if (avatarRaw != null && avatarRaw.isNotEmpty) {
      avatarUrl = avatarRaw.startsWith('http')
          ? avatarRaw
          : '${ApiEndpoints.baseUrl}$avatarRaw';
    }

    return ProfileModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      firstName: json[ApiKeys.firstName]?.toString() ?? '',
      secondName: json[ApiKeys.secondName]?.toString() ?? '',
      email: json[ApiKeys.email]?.toString() ?? '',
      jobTitle: json[ApiKeys.jobTitle]?.toString(),
      dateOfBirth: json[ApiKeys.dateOfBirth]?.toString(),
      profileImage: avatarUrl,
    );
  }

  //  toJson
  Map<String, dynamic> toJson() => {
    ApiKeys.id: id,
    ApiKeys.firstName: firstName,
    ApiKeys.secondName: secondName,
    ApiKeys.email: email,
    if (jobTitle != null) ApiKeys.jobTitle: jobTitle,
    if (dateOfBirth != null) ApiKeys.dateOfBirth: dateOfBirth,
  };

  //  copyWith
  ProfileModel copyWith({
    String? firstName,
    String? secondName,
    String? jobTitle,
    String? dateOfBirth,
    String? profileImage,
  }) => ProfileModel(
    id: id,
    firstName: firstName ?? this.firstName,
    secondName: secondName ?? this.secondName,
    email: email,
    jobTitle: jobTitle ?? this.jobTitle,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    profileImage: profileImage ?? this.profileImage,
  );
}
