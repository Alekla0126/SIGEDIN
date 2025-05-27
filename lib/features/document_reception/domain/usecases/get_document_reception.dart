import 'package:dartz/dartz.dart';
import 'package:aucips/core/error/failures.dart';
import 'package:aucips/features/document_reception/domain/entities/document_reception.dart';
import 'package:aucips/features/document_reception/domain/repositories/document_reception_repository.dart';

class GetDocumentReception {
  final DocumentReceptionRepository repository;

  GetDocumentReception(this.repository);

  Future<Either<Failure, DocumentReception>> call(int id) async {
    return await repository.getDocumentReception(id);
  }
}
