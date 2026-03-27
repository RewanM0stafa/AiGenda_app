
import '../../data/models/profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

// Get Profile
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  ProfileLoaded({required this.profile});
}

class ProfileError extends ProfileState {
  final String errMessage;
  ProfileError({required this.errMessage});
}

// Update Profile
class UpdateProfileLoading extends ProfileState {
  final ProfileModel profile;
  UpdateProfileLoading({required this.profile});
}

class UpdateProfileSuccess extends ProfileState {
  final ProfileModel profile;
  UpdateProfileSuccess({required this.profile});
}

class UpdateProfileFailure extends ProfileState {
  final ProfileModel profile;
  final String errMessage;
  UpdateProfileFailure({required this.profile, required this.errMessage});
}

// Change Password
class ChangePasswordLoading extends ProfileState {}
class ChangePasswordSuccess extends ProfileState {}

class ChangePasswordFailure extends ProfileState {
  final String errMessage;
  ChangePasswordFailure({required this.errMessage});
}

// Change Email
class ChangeEmailLoading extends ProfileState {}
class ChangeEmailSuccess extends ProfileState {}

class ChangeEmailFailure extends ProfileState {
  final String errMessage;
  ChangeEmailFailure({required this.errMessage});
}

// Confirm Change Email
class ConfirmChangeEmailLoading extends ProfileState {}
class ConfirmChangeEmailSuccess extends ProfileState {}

class ConfirmChangeEmailFailure extends ProfileState {
  final String errMessage;
  ConfirmChangeEmailFailure({required this.errMessage});
}

// Avatar
class UploadAvatarLoading extends ProfileState {}

class UploadAvatarSuccess extends ProfileState {
  final String avatarUrl;
  UploadAvatarSuccess({required this.avatarUrl});
}

class UploadAvatarFailure extends ProfileState {
  final String errMessage;
  UploadAvatarFailure({required this.errMessage});
}








/*
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// Update
class UpdateProfileLoading extends ProfileState {
  final ProfileModel profile;
  UpdateProfileLoading(this.profile);
}

class UpdateProfileSuccess extends ProfileState {
  final ProfileModel profile;
  UpdateProfileSuccess(this.profile);
}

class UpdateProfileFailure extends ProfileState {
  final ProfileModel profile;
  final String message;
  UpdateProfileFailure(this.profile, this.message);
}

// Password
class ChangePasswordLoading extends ProfileState {}

class ChangePasswordSuccess extends ProfileState {}

class ChangePasswordFailure extends ProfileState {
  final String message;
  ChangePasswordFailure(this.message);
}

// Avatar
class AvatarLoading extends ProfileState {
  final ProfileModel profile;
  AvatarLoading(this.profile);
}

class AvatarSuccess extends ProfileState {
  final ProfileModel profile;
  AvatarSuccess(this.profile);
}

class AvatarFailure extends ProfileState {
  final ProfileModel profile;
  final String message;
  AvatarFailure(this.profile, this.message);
}
*/



