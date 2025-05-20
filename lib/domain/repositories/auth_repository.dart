import '../entities/user.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isAuthenticated();
}
