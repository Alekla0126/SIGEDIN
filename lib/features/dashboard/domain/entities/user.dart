import 'package:equatable/equatable.dart';

class DashboardUser extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final bool isActive;
  final DateTime? lastLogin;
  final Map<String, dynamic>? metadata;

  const DashboardUser({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.isActive = true,
    this.lastLogin,
    this.metadata,
  });

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
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

  @override
  List<Object?> get props => [id, email, fullName, isActive];

  DashboardUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    bool? isActive,
    DateTime? lastLogin,
    Map<String, dynamic>? metadata,
  }) {
    return DashboardUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      metadata: metadata ?? this.metadata,
    );
  }
}
