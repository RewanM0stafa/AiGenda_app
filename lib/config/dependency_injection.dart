import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/network/api_service.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_storage_service.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/logic/auth_cubit/auth_cubit.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/logic/profile_cubit/profile_cubit.dart';
import '../features/worksspace/data/data_source/workspace_remote_data_source.dart';
import '../features/worksspace/data/repository/workspace_repository_impl.dart';
import '../features/worksspace/domain/workspace_repository.dart';
import '../features/worksspace/logic/member_cubit/member_cubit.dart';
import '../features/worksspace/logic/permission_cubit/permission_cubit.dart';
import '../features/worksspace/logic/workspace_cubit/workspace_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  //  Core

  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<DioClient>(
        () => DioClient(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ApiService>(
        () => ApiService(getIt<DioClient>().dio),
  );

  getIt.registerLazySingleton<SecureStorageService>(
        () => SecureStorageService(),
  );

  //  Auth

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      apiService: getIt<ApiService>(),
      storage: getIt<SecureStorageService>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
        () => AuthCubit(
      getIt<AuthRepository>(),
      getIt<SecureStorageService>(),
    ),
  );

  //  Profile

  getIt.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerLazySingleton<ProfileCubit>(
        () => ProfileCubit(getIt<ProfileRepository>()),
  );

  //  Workspaces

  getIt.registerLazySingleton<WorkspaceRemoteDataSource>(
        () => WorkspaceRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<WorkspaceRepository>(
        () => WorkspaceRepositoryImpl(getIt()),
  );

  getIt.registerFactory<WorkspaceCubit>(
        () => WorkspaceCubit(getIt()),
  );

  getIt.registerFactory<MembersCubit>(
        () => MembersCubit(getIt()),
  );

  getIt.registerFactory<PermissionsCubit>(
        () => PermissionsCubit(getIt()),
  );
}

/*
import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import '../core/network/api_service.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_storage_service.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/logic/auth_cubit/auth_cubit.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/logic/profile_cubit/profile_cubit.dart';
final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  // ── Core ──
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<DioClient>(
        () => DioClient(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ApiService>(
        () => ApiService(getIt<DioClient>().dio),
  );

  getIt.registerLazySingleton<SecureStorageService>(
        () => SecureStorageService(),
  );

  // ── Auth ──
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      apiService: getIt<ApiService>(),
      storage: getIt<SecureStorageService>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
        () => AuthCubit(
      getIt<AuthRepository>(),
      getIt<SecureStorageService>(),
    ),
  );
// Profile
  getIt.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerFactory<ProfileCubit>(
        () => ProfileCubit(getIt<ProfileRepository>()),
  );
}

 */
