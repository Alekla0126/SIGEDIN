import 'dart:developer' as developer;
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'dashboard_remote_data_source.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient client;

  DashboardRemoteDataSourceImpl({required this.client});

  @override
  Future<DashboardUser> getCurrentUser() async {
    developer.log('🔍 Fetching current user...', name: 'DashboardRemoteDataSource');
    final response = await client.get<DashboardUser>(
      '/auth/me',
      fromJson: (json) {
        developer.log('🔍 Current user data: $json', name: 'DashboardRemoteDataSource');
        if (json is Map<String, dynamic> && json.containsKey('data') && json['data'] != null) {
          developer.log('🔍 Parsing user data: ${json['data']}', name: 'DashboardRemoteDataSource');
          final user = UserModel.fromJson(json['data'] as Map<String, dynamic>).toEntity();
          developer.log('✅ Successfully parsed user: ${user.email}', name: 'DashboardRemoteDataSource');
          return user;
        }
        developer.log('❌ No user data found in response', name: 'DashboardRemoteDataSource');
        throw Exception('No user data found in response');
      },
    );
    
    return response.fold(
      (failure) {
        developer.log('❌ Failed to fetch current user: ${failure.message}', name: 'DashboardRemoteDataSource', error: failure);
        throw failure;
      },
      (user) => user,
    );
  }

  @override
  Future<List<DashboardUser>> getUsers() async {
    final response = await client.get<List<DashboardUser>>(
      '/users',
      fromJson: (json) => (json as List)
          .map((user) => UserModel.fromJson(user as Map<String, dynamic>).toEntity())
          .toList()
          .cast<DashboardUser>(),
    );
    
    return response.fold(
      (failure) => throw failure,
      (users) => users,
    );
  }

  @override
  Future<DashboardUser> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    final response = await client.put<DashboardUser>(
      '/users/$userId',
      body: updates,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>).toEntity(),
    );
    
    return response.fold(
      (failure) => throw failure,
      (user) => user,
    );
  }
}
