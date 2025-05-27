import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/document_type_repository.dart';

class DeleteDocumentType {
  final DocumentTypeRepository repository;

  DeleteDocumentType(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteDocumentType(id);
  }
}
