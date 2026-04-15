import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/models/change_email_request.dart';
import '../../data/models/change_password_request.dart';
import '../../data/models/confirm_change_email_request.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/update_profile_request.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final SecureStorageService storage;

  ProfileCubit(this.profileRepository, this.storage) : super(ProfileInitial());
  ProfileModel? get currentProfile {
    final s = state;
    if (s is ProfileLoaded) return s.profile;
    if (s is UpdateProfileSuccess) return s.profile;
    if (s is UpdateProfileLoading) return s.profile;
    if (s is UpdateProfileFailure) return s.profile;
    return null;
  }

  Future<void> getProfile() async {
    if (currentProfile != null) return;
    emit(ProfileLoading());
    final result = await profileRepository.getProfile();
    result.fold(
      (failure) => emit(ProfileError(errMessage: failure)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> refreshProfile() async {
    emit(ProfileLoading());
    final result = await profileRepository.getProfile();
    result.fold(
      (failure) => emit(ProfileError(errMessage: failure)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> updateProfile({
    required String firstName,
    required String secondName,
    required String dateOfBirth,
    String? jobTitle,
  }) async {
    final current = currentProfile;
    if (current == null) return;

    emit(UpdateProfileLoading(profile: current));
    final result = await profileRepository.updateProfile(
      UpdateProfileRequest(
        firstName: firstName,
        secondName: secondName,
        dateOfBirth: dateOfBirth,
        jobTitle: jobTitle,
      ),
    );
    result.fold(
      (failure) =>
          emit(UpdateProfileFailure(profile: current, errMessage: failure)),
      (profile) => emit(UpdateProfileSuccess(profile: profile)),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());
    final result = await profileRepository.changePassword(
      ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    result.fold(
      (failure) => emit(ChangePasswordFailure(errMessage: failure)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }

  Future<void> changeEmail({required String newEmail}) async {
    emit(ChangeEmailLoading());
    final result = await profileRepository.changeEmail(
      ChangeEmailRequest(newEmail: newEmail),
    );
    result.fold(
      (failure) => emit(ChangeEmailFailure(errMessage: failure)),
      (_) => emit(ChangeEmailSuccess()),
    );
  }

  Future<void> confirmChangeEmail({
    String? id,
    required String newEmail,
    required String code,
  }) async {
    emit(ConfirmChangeEmailLoading());

    final finalId = id?.isNotEmpty == true ? id! : await storage.getUserId();

    if (finalId == null || finalId.isEmpty) {
      emit(ConfirmChangeEmailFailure(errMessage: "User ID not found."));
      return;
    }

    final result = await profileRepository.confirmChangeEmail(
      ConfirmChangeEmailRequest(id: finalId, newEmail: newEmail, code: code),
    );

    result.fold(
      (failure) => emit(ConfirmChangeEmailFailure(errMessage: failure)),
      (_) => emit(ConfirmChangeEmailSuccess()),
    );
  }

  Future<void> uploadAvatar(String filePath) async {
    final current = currentProfile;
    if (current == null) return;

    emit(UploadAvatarLoading());
    final result = await profileRepository.uploadAvatar(filePath);
    result.fold((failure) => emit(UploadAvatarFailure(errMessage: failure)), (
      url,
    ) {
      final updatedProfile = current.copyWith(profileImage: url);
      emit(ProfileLoaded(profile: updatedProfile));
    });
  }

  Future<void> deleteAvatar() async {
    final current = currentProfile;
    if (current == null) return;

    final result = await profileRepository.deleteAvatar();
    result.fold((failure) => emit(UploadAvatarFailure(errMessage: failure)), (
      _,
    ) {
      final updatedProfile = current.copyWith(profileImage: null);
      emit(ProfileLoaded(profile: updatedProfile));
    });
  }
}
