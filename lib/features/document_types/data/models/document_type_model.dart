import '../../domain/entities/document_type.dart';

class DocumentTypeModel extends DocumentType {
  DocumentTypeModel({
    required super.id,
    required super.name,
    super.description,
    required super.createdAt,
    super.updatedAt,
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  factory DocumentTypeModel.fromEntity(DocumentType documentType) {
    return DocumentTypeModel(
      id: documentType.id,
      name: documentType.name,
      description: documentType.description,
      createdAt: documentType.createdAt,
      updatedAt: documentType.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
