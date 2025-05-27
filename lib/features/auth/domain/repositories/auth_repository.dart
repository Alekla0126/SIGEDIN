import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> getCurrentUser();
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> isAuthenticated();
}
