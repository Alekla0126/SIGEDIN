import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/document_type.dart';
import '../repositories/document_type_repository.dart';

class UpdateDocumentType {
  final DocumentTypeRepository repository;

  UpdateDocumentType(this.repository);

  Future<Either<Failure, DocumentType>> call({
    required String id,
    String? name,
    String? description,
  }) async {
    return await repository.updateDocumentType(
      id: id,
      name: name,
      description: description,
    );
  }
}
