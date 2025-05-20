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
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCurrentUser = null;
    return;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _mockCurrentUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _mockCurrentUser != null;
  }
}
