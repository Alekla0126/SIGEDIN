import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/document_type.dart';
import '../repositories/document_type_repository.dart';

class GetDocumentTypes {
  final DocumentTypeRepository repository;

  GetDocumentTypes(this.repository);

  Future<Either<Failure, List<DocumentType>>> call() async {
    return await repository.getDocumentTypes();
  }
}
