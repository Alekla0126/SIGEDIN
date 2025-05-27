import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/document_type.dart';
import '../repositories/document_type_repository.dart';

class GetDocumentType {
  final DocumentTypeRepository repository;

  GetDocumentType(this.repository);

  Future<Either<Failure, DocumentType>> call(String id) async {
    return await repository.getDocumentType(id);
  }
}
