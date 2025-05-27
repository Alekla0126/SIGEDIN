import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'features/dashboard/data/datasources/dashboard_remote_data_source_impl.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/get_current_user_usecase.dart';

// Import for Dashboard Stats
import 'features/dashboard/data/datasources/dashboard_stats_remote_data_source.dart';
import 'features/dashboard/data/repositories/dashboard_stats_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_stats_repository.dart';
import 'features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart'; // Added import for the use case
import 'features/dashboard/domain/usecases/get_dashboard_data_usecase.dart'; // Import GetDashboardDataUseCase

import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/document_reception/di/document_reception_injection.dart' as doc_reception;

final sl = GetIt.instance;

Future<void> init() async {
  // External
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }
  
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }

  // Core
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton(() => ApiClient(
          client: sl(),
          prefs: sl(),
        ));
  }

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl(),
      prefs: sl(),
    ),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  // Register DashboardStatsRemoteDataSource
  sl.registerLazySingleton<DashboardStatsRemoteDataSource>(
    () => DashboardStatsRemoteDataSourceImpl(
      apiClient: sl(), // Use apiClient
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Register DashboardStatsRepository
  sl.registerLazySingleton<DashboardStatsRepository>(
    () => DashboardStatsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
    () => LoginUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => GetCurrentUserUseCase(sl()),
  );

  // Register GetDashboardStatsUseCase
  sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));

  // Register GetDashboardDataUseCase
  sl.registerLazySingleton(() => GetDashboardDataUseCase(repository: sl(), getCurrentUserUseCase: sl()));

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      repository: sl<AuthRepository>(),
    ),
  );

  sl.registerFactory(
    () => DashboardBloc(
      getDashboardDataUseCase: sl(), // Corrected: Add GetDashboardDataUseCase
      getDashboardStatsUseCase: sl(), // Add GetDashboardStatsUseCase
    ),
  );
  
  // Initialize Document Reception Feature
  await doc_reception.initDocumentReceptionFeature();
}
