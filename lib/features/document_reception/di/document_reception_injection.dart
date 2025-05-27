import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:aucips/core/network/api_client.dart';
import 'package:aucips/features/document_reception/data/datasources/document_reception_remote_data_source.dart';
import 'package:aucips/features/document_reception/data/repositories/document_reception_repository_impl.dart';
import 'package:aucips/features/document_reception/domain/repositories/document_reception_repository.dart';
import 'package:aucips/features/document_reception/domain/usecases/create_document_reception.dart';
import 'package:aucips/features/document_reception/domain/usecases/get_document_reception.dart';
import 'package:aucips/features/document_reception/domain/usecases/download_document_file.dart';
import 'package:aucips/features/document_reception/presentation/bloc/document_reception_bloc.dart';

final sl = GetIt.instance;

Future<void> initDocumentReceptionFeature() async {
  // Bloc
  sl.registerFactory(
    () => DocumentReceptionBloc(
      createDocumentReception: sl(),
      getDocumentReception: sl(),
      downloadDocumentFile: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateDocumentReception(sl()));
  sl.registerLazySingleton(() => GetDocumentReception(sl()));
  sl.registerLazySingleton(() => DownloadDocumentFile(sl()));

  // Repository
  sl.registerLazySingleton<DocumentReceptionRepository>(
    () => DocumentReceptionRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<DocumentReceptionRemoteDataSource>(
    () => DocumentReceptionRemoteDataSourceImpl(
      apiClient: sl(),
    ),
  );

  // External dependencies
  // Only register SharedPreferences if not already registered
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }
  
  // Only register http.Client if not already registered
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }
  
  // API Client
  // Only register ApiClient if not already registered
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton(
      () => ApiClient(
        client: sl(),
        prefs: sl(),
      ),
    );
  }
}
