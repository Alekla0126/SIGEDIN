import 'package:dartz/dartz.dart';
import 'package:aucips/core/error/failures.dart';
import 'package:aucips/features/document_reception/domain/entities/document_reception.dart';

abstract class DocumentReceptionRepository {
  Future<Either<Failure, DocumentReception>> createDocumentReception({
    required String tipo,
    required String remitente,
    required String asunto,
    required bool requiereAcuse,
    required DateTime fechaRecepcion,
    required String titularDe,
    String? observaciones,
    int? plazoAtencion,
    required String filePath,
  });

  Future<Either<Failure, DocumentReception>> getDocumentReception(int id);
  
  Future<Either<Failure, String>> downloadDocumentFile(int id);
}
