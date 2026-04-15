import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/change_email_request.dart';
import '../models/change_password_request.dart';
import '../models/confirm_change_email_request.dart';
import '../models/profile_model.dart';
import '../models/update_profile_request.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiService apiService;

  ProfileRepositoryImpl({required this.apiService});

  String _handleError(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final pd = data['problemDetails'];
        if (pd != null) {
          final errors = pd['error'] as List?;
          if (errors != null && errors.length >= 2) return errors[1].toString();
          if (errors != null && errors.isNotEmpty) return errors[0].toString();
          if (pd['title'] != null) return pd['title'].toString();
        }
        if (data['message'] != null) return data['message'].toString();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Connection timeout. Check your internet.';
      }
      return 'Connection error. Check your internet.';
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  Future<Either<String, ProfileModel>> getProfile() async {
    try {
      final response = await apiService.get(ApiEndpoints.me);
      return Right(ProfileModel.fromJson(response as Map<String, dynamic>));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, ProfileModel>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    try {
      final response = await apiService.put(
        ApiEndpoints.updateMe,
        data: request.toJson(),
      );
      return Right(ProfileModel.fromJson(response as Map<String, dynamic>));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      await apiService.put(ApiEndpoints.changePassword, data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> changeEmail(ChangeEmailRequest request) async {
    try {
      await apiService.post(ApiEndpoints.changeEmail, data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> confirmChangeEmail(
    ConfirmChangeEmailRequest request,
  ) async {
    try {
      await apiService.put(
        ApiEndpoints.confirmChangeEmail,
        data: request.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, String>> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'File': await MultipartFile.fromFile(filePath),
      });

      final response = await apiService.post(
        ApiEndpoints.uploadAvatar,
        data: formData,
      );

      if (response is Map<String, dynamic>) {
        final relativePath = response['avatarUrl'] ?? '';

        if (relativePath.isNotEmpty) {
          final fullUrl = "${ApiEndpoints.baseUrl}$relativePath";
          return Right(fullUrl);
        }
      }
      return Left('Could not parse image URL');
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> deleteAvatar() async {
    try {
      await apiService.delete(ApiEndpoints.deleteAvatar);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
