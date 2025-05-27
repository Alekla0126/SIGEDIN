import 'package:equatable/equatable.dart';

import '../../domain/entities/document_type.dart';

enum DocumentTypeStatus { initial, loading, success, failure }

class DocumentTypeState extends Equatable {
  final DocumentTypeStatus status;
  final List<DocumentType> documentTypes;
  final DocumentType? currentDocumentType;
  final String? error;

  const DocumentTypeState({
    this.status = DocumentTypeStatus.initial,
    this.documentTypes = const [],
    this.currentDocumentType,
    this.error,
  });

  DocumentTypeState copyWith({
    DocumentTypeStatus? status,
    List<DocumentType>? documentTypes,
    DocumentType? currentDocumentType,
    String? error,
  }) {
    return DocumentTypeState(
      status: status ?? this.status,
      documentTypes: documentTypes ?? this.documentTypes,
      currentDocumentType: currentDocumentType ?? this.currentDocumentType,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, documentTypes, currentDocumentType, error];
}
