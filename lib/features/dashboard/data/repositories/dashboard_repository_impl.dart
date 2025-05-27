import '../../domain/entities/user.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardUser> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DashboardUser>> getUsers() async {
    try {
      return await remoteDataSource.getUsers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashboardUser> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      return await remoteDataSource.updateUserProfile(
        userId: userId,
        updates: updates,
      );
    } catch (e) {
      rethrow;
    }
  }
}
