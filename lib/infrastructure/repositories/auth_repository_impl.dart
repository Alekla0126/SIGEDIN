import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  User? _mockCurrentUser;

  static const _mockUsers = [
    User(
      id: '1',
      email: 'admin@ucips.gob.mx',
      fullName: 'Administrador del Sistema',
      role: 'ADMIN',
      permissions: [
        'documents.create',
        'documents.read',
        'documents.update',
        'documents.delete',
        'users.manage',
        'audit.view',
      ],
    ),
    User(
      id: '2',
      email: 'auditor@ucips.gob.mx',
      fullName: 'Auditor Institucional',
      role: 'AUDITOR',
      permissions: [
        'audit.view',
        'documents.read',
      ],
    ),
    User(
      id: '3',
      email: 'gestion@ucips.gob.mx',
      fullName: 'Gestión Documental',
      role: 'GESTION',
      permissions: [
        'documents.create',
        'documents.read',
        'documents.update',
        'documents.turn',
        'documents.ack',
      ],
    ),
  ];

  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = _mockUsers.firstWhere(
      (u) => u.email == email && password == 'admin123',
      orElse: () => throw Exception('Credenciales inválidas'),
    );
    _mockCurrentUser = user;
    // Guardar login en cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', user.email);
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCurrentUser = null;
    // Limpiar cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail');
    return;
  }

  @override
  Future<User?> getCurrentUser() async {
    if (_mockCurrentUser != null) return _mockCurrentUser;
    // Intentar restaurar usuario desde cache
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null) {
      final user = _mockUsers.firstWhere(
        (u) => u.email == email,
        orElse: () => _mockUsers.first,
      );
      _mockCurrentUser = user;
      return user;
    }
    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    if (_mockCurrentUser != null) return true;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
