import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final bool isActive;
  final DateTime? lastLogin;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.isActive = true,
    this.lastLogin,
    this.metadata,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? json['fullName'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      lastLogin: json['last_login'] != null 
          ? DateTime.tryParse(json['last_login'].toString())
          : null,
      metadata: json['metadata'] is Map ? Map<String, dynamic>.from(json['metadata']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (fullName != null) 'full_name': fullName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'is_active': isActive,
      if (lastLogin != null) 'last_login': lastLogin?.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  DashboardUser toEntity() {
    return DashboardUser(
      id: id,
      email: email,
      fullName: fullName,
      avatarUrl: avatarUrl,
      isActive: isActive,
      lastLogin: lastLogin,
      metadata: metadata,
    );
  }
}
