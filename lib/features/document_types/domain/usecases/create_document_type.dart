import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/document_type.dart';
import '../repositories/document_type_repository.dart';

class CreateDocumentType {
  final DocumentTypeRepository repository;

  CreateDocumentType(this.repository);

  Future<Either<Failure, DocumentType>> call({
    required String name,
    String? description,
  }) async {
    return await repository.createDocumentType(
      name: name,
      description: description,
    );
  }
}
