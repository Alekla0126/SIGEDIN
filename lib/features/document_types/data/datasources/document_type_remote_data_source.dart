import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/document_type.dart';

abstract class DocumentTypeRemoteDataSource {
  Future<List<DocumentType>> getDocumentTypes();
  Future<DocumentType> getDocumentType(String id);
  Future<DocumentType> createDocumentType({
    required String name,
    String? description,
  });
  Future<DocumentType> updateDocumentType({
    required String id,
    String? name,
    String? description,
  });
  Future<void> deleteDocumentType(String id);
}
