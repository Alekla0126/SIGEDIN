import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/document_type.dart';

abstract class DocumentTypeRepository {
  // Get all document types
  Future<Either<Failure, List<DocumentType>>> getDocumentTypes();
  
  // Get a single document type by ID
  Future<Either<Failure, DocumentType>> getDocumentType(String id);
  
  // Create a new document type
  Future<Either<Failure, DocumentType>> createDocumentType({
    required String name,
    String? description,
  });
  
  // Update an existing document type
  Future<Either<Failure, DocumentType>> updateDocumentType({
    required String id,
    String? name,
    String? description,
  });
  
  // Delete a document type
  Future<Either<Failure, void>> deleteDocumentType(String id);
}
