import '../../domain/entities/user.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardUser> getCurrentUser();
  Future<List<DashboardUser>> getUsers();
  Future<DashboardUser> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  });
}
