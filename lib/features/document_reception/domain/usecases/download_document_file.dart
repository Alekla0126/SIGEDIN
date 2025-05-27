import 'package:dartz/dartz.dart';
import 'package:aucips/core/error/failures.dart';
import 'package:aucips/features/document_reception/domain/repositories/document_reception_repository.dart';

class DownloadDocumentFile {
  final DocumentReceptionRepository repository;

  DownloadDocumentFile(this.repository);

  Future<Either<Failure, String>> call(int id) async {
    return await repository.downloadDocumentFile(id);
  }
}
