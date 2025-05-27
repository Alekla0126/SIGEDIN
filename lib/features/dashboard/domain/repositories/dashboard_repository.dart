import '../entities/user.dart';

abstract class DashboardRepository {
  Future<DashboardUser> getCurrentUser();
  Future<List<DashboardUser>> getUsers();
  Future<DashboardUser> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  });
}
