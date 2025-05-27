class User {
  final int? id;
  final String? email;
  final String? fullName;
  final String? role;
  final int? areaId;
  final bool? isActive;
  final DateTime? createdAt;

  User({
    this.id,
    this.email,
    this.fullName,
    this.role,
    this.areaId,
    this.isActive,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _parseInt(json['id']),
      email: json['email']?.toString(),
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString(),
      role: json['role']?.toString(),
      areaId: _parseInt(json['area_id'] ?? json['areaId']),
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
    );
  }
  
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
  
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (email != null) map['email'] = email;
    if (fullName != null) map['full_name'] = fullName;
    if (role != null) map['role'] = role;
    if (areaId != null) map['area_id'] = areaId;
    if (isActive != null) map['is_active'] = isActive;
    if (createdAt != null) map['created_at'] = createdAt!.toIso8601String();
    return map;
  }
}
