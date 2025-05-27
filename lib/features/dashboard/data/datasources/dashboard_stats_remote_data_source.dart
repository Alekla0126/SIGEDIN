import 'dart:developer' as developer;
import '../../../../core/errors/exceptions.dart';
import '../models/dashboard_stats_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/errors/failures.dart'; // Corrected path based on ApiClient
import 'package:dartz/dartz.dart';

abstract class DashboardStatsRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardStatsRemoteDataSourceImpl implements DashboardStatsRemoteDataSource {
  final ApiClient apiClient;

  DashboardStatsRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    developer.log('Fetching dashboard stats...', name: 'DashboardStatsRemoteDataSource');
    
    // Se mantiene la URL como '/api/dashboard', si necesita cambiar se ajustaría aquí
    final Either<Failure, dynamic> response = await apiClient.get(
      '/api/dashboard',
    );

    return response.fold(
      (failure) {
        developer.log('Error fetching dashboard stats: ${failure.toString()}', name: 'DashboardStatsRemoteDataSource', error: failure);
        String errorMessage = failure is ServerFailure ? failure.message : failure.toString();
        throw ServerException(message: errorMessage);
      },
      (data) {
        developer.log('Successfully fetched dashboard stats: $data', name: 'DashboardStatsRemoteDataSource');
        if (data is Map<String, dynamic>) {
          // Verificar si la respuesta sigue la estructura anidada {success, message, data}
          if (data.containsKey('success') && data.containsKey('data') && data['data'] != null) {
            developer.log('Processing nested response structure', name: 'DashboardStatsRemoteDataSource');
            final stats = DashboardStatsModel.fromJson(data['data']);
            developer.log('Parsed dashboard stats from nested data: $stats', name: 'DashboardStatsRemoteDataSource');
            return stats;
          } else {
            // Mantener el comportamiento existente para respuestas no anidadas
            final stats = DashboardStatsModel.fromJson(data);
            developer.log('Parsed dashboard stats from direct data: $stats', name: 'DashboardStatsRemoteDataSource');
            return stats;
          }
        } else {
          developer.log('Invalid data format received: $data', name: 'DashboardStatsRemoteDataSource', error: 'Invalid data format');
          throw ServerException(message: 'Invalid data format received from API. Expected a Map.');
        }
      },
    );
  }
}
