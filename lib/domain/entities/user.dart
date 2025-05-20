import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final List<String> permissions;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.permissions,
  });

  @override
  List<Object> get props => [id, email, fullName, role, permissions];
}
