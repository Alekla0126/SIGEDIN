import 'package:dartz/dartz.dart';
import 'package:aucips/core/error/failures.dart';
import 'package:aucips/features/document_reception/domain/entities/document_reception.dart';
import 'package:aucips/features/document_reception/domain/repositories/document_reception_repository.dart';

class CreateDocumentReception {
  final DocumentReceptionRepository repository;

  CreateDocumentReception(this.repository);

  Future<Either<Failure, DocumentReception>> call({
    required String tipo,
    required String remitente,
    required String asunto,
    required bool requiereAcuse,
    required DateTime fechaRecepcion,
    required String titularDe,
    String? observaciones,
    int? plazoAtencion,
    required String filePath,
  }) async {
    return await repository.createDocumentReception(
      tipo: tipo,
      remitente: remitente,
      asunto: asunto,
      requiereAcuse: requiereAcuse,
      fechaRecepcion: fechaRecepcion,
      titularDe: titularDe,
      observaciones: observaciones,
      plazoAtencion: plazoAtencion,
      filePath: filePath,
    );
  }
}
