import 'package:dartz/dartz.dart';
import '../../data/models/change_email_request.dart';
import '../../data/models/change_password_request.dart';
import '../../data/models/confirm_change_email_request.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/update_profile_request.dart';

abstract class ProfileRepository {
  Future<Either<String, ProfileModel>> getProfile();
  Future<Either<String, ProfileModel>> updateProfile(UpdateProfileRequest request);
  Future<Either<String, void>> changePassword(ChangePasswordRequest request);
  Future<Either<String, void>> changeEmail(ChangeEmailRequest request);
  Future<Either<String, void>> confirmChangeEmail(ConfirmChangeEmailRequest request);
  Future<Either<String, String>> uploadAvatar(String filePath);
  Future<Either<String, void>> deleteAvatar();
}
 