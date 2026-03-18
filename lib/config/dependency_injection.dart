import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/network/api_service.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_storage_service.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/logic/auth_cubit/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  // ── Core ──
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));
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
}