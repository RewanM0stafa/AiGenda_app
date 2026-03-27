// ════════════════════════════════════════════════════════════
// 📁 features/profile/logic/profile_cubit/profile_cubit.dart
// ════════════════════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/change_email_request.dart';
import '../../data/models/change_password_request.dart';
import '../../data/models/confirm_change_email_request.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/update_profile_request.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit(this.profileRepository) : super(ProfileInitial());

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
    required String dateOfBirth, // yyyy-MM-dd — required
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
          (failure) => emit(UpdateProfileFailure(profile: current, errMessage: failure)),
          (profile) => emit(UpdateProfileSuccess(profile: profile)),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());
    final result = await profileRepository.changePassword(
      ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword),
    );
    result.fold(
          (failure) => emit(ChangePasswordFailure(errMessage: failure)),
          (_) => emit(ChangePasswordSuccess()),
    );
  }

  Future<void> changeEmail({required String newEmail}) async {
    emit(ChangeEmailLoading());
    final result = await profileRepository.changeEmail(ChangeEmailRequest(newEmail: newEmail));
    result.fold(
          (failure) => emit(ChangeEmailFailure(errMessage: failure)),
          (_) => emit(ChangeEmailSuccess()),
    );
  }

  Future<void> confirmChangeEmail({
    required String id,
    required String newEmail,
    required String code,
  }) async {
    emit(ConfirmChangeEmailLoading());
    final result = await profileRepository.confirmChangeEmail(
      ConfirmChangeEmailRequest(id: id, newEmail: newEmail, code: code),
    );
    result.fold(
          (failure) => emit(ConfirmChangeEmailFailure(errMessage: failure)),
          (_) => emit(ConfirmChangeEmailSuccess()),
    );
  }

  // ── Avatar — بعد الرفع نحدث الـ profile مباشرة في الـ state ──
  Future<void> uploadAvatar(String filePath) async {
    final current = currentProfile;
    if (current == null) return;

    emit(UploadAvatarLoading());
    final result = await profileRepository.uploadAvatar(filePath);
    result.fold(
          (failure) => emit(UploadAvatarFailure(errMessage: failure)),
          (url) {
        // نحدث الـ profile بالـ avatar الجديد عشان الـ UI يتحدث تلقائياً
        final updatedProfile = current.copyWith(profileImage: url);
        emit(ProfileLoaded(profile: updatedProfile));
      },
    );
  }

  Future<void> deleteAvatar() async {
    final current = currentProfile;
    if (current == null) return;

    final result = await profileRepository.deleteAvatar();
    result.fold(
          (failure) => emit(UploadAvatarFailure(errMessage: failure)),
          (_) {
        final updatedProfile = current.copyWith(profileImage: null);
        emit(ProfileLoaded(profile: updatedProfile));
      },
    );
  }
}
/*
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repo;

  ProfileCubit(this.repo) : super(ProfileInitial());

  ProfileModel? get current {
    final s = state;
    if (s is ProfileLoaded) return s.profile;
    if (s is UpdateProfileSuccess) return s.profile;
    if (s is UpdateProfileLoading) return s.profile;
    if (s is AvatarSuccess) return s.profile;
    if (s is AvatarLoading) return s.profile;
    return null;
  }

  Future<void> load() async {
    emit(ProfileLoading());
    final res = await repo.getProfile();

    res.fold(
          (e) => emit(ProfileError(e)),
          (p) => emit(ProfileLoaded(p)),
    );
  }

  Future<void> update(UpdateProfileRequest req) async {
    final currentProfile = current;
    if (currentProfile == null) return;

    emit(UpdateProfileLoading(currentProfile));

    final res = await repo.updateProfile(req);

    res.fold(
          (e) => emit(UpdateProfileFailure(currentProfile, e)),
          (p) => emit(UpdateProfileSuccess(p)),
    );
  }

  Future<void> changePassword(ChangePasswordRequest req) async {
    emit(ChangePasswordLoading());

    final res = await repo.changePassword(req);

    res.fold(
          (e) => emit(ChangePasswordFailure(e)),
          (_) => emit(ChangePasswordSuccess()),
    );
  }

  Future<void> uploadAvatar(String path) async {
    final currentProfile = current;
    if (currentProfile == null) return;

    emit(AvatarLoading(currentProfile));

    final res = await repo.uploadAvatar(path);

    res.fold(
          (e) => emit(AvatarFailure(currentProfile, e)),
          (url) {
        emit(AvatarSuccess(
          currentProfile.copyWith(profileImage: url),
        ));
      },
    );
  }

  Future<void> deleteAvatar() async {
    final currentProfile = current;
    if (currentProfile == null) return;

    emit(AvatarLoading(currentProfile));

    final res = await repo.deleteAvatar();

    res.fold(
          (e) => emit(AvatarFailure(currentProfile, e)),
          (_) {
        emit(AvatarSuccess(
          currentProfile.copyWith(profileImage: null),
        ));
      },
    );
  }
}

 */
/*
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  // ── Getter للـ profile الحالي ──
  ProfileModel? get currentProfile {
    final state = this.state;
    if (state is ProfileLoaded) return state.profile;
    if (state is UpdateProfileSuccess) return state.profile;
    if (state is UpdateProfileLoading) return state.profile;
    if (state is UpdateProfileFailure) return state.profile;
    return null;
  }

  Future<void> getProfile() async {
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
    String? jobTitle,
    String? dateOfBirth,
  }) async {
    final current = currentProfile;
    if (current == null) return;

    emit(UpdateProfileLoading(profile: current));
    final result = await profileRepository.updateProfile(
      UpdateProfileRequest(
        firstName: firstName,
        secondName: secondName,
        jobTitle: jobTitle,
        dateOfBirth: dateOfBirth,
      ),
    );
    result.fold(
          (failure) => emit(UpdateProfileFailure(profile: current, errMessage: failure)),
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
    required String id,
    required String newEmail,
    required String code,
  }) async {
    emit(ConfirmChangeEmailLoading());
    final result = await profileRepository.confirmChangeEmail(
      ConfirmChangeEmailRequest(id: id, newEmail: newEmail, code: code),
    );
    result.fold(
          (failure) => emit(ConfirmChangeEmailFailure(errMessage: failure)),
          (_) => emit(ConfirmChangeEmailSuccess()),
    );
  }
}

 */