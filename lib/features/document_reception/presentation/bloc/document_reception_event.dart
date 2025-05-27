import 'package:equatable/equatable.dart';

abstract class DocumentReceptionEvent extends Equatable {
  const DocumentReceptionEvent();

  @override
  List<Object?> get props => [];
}

class CreateDocumentReceptionEvent extends DocumentReceptionEvent {
  final String asunto;
  final String remitente;
  final String tipo;
  final String titularDe;
  final DateTime fechaRecepcion;
  final bool requiereAcuse;
  final String filePath;
  final String? observaciones;
  final int? plazoAtencion;

  const CreateDocumentReceptionEvent({
    required this.asunto,
    required this.remitente,
    required this.tipo,
    required this.titularDe,
    required this.fechaRecepcion,
    required this.requiereAcuse,
    required this.filePath,
    this.observaciones,
    this.plazoAtencion,
  });

  @override
  List<Object?> get props => [
        asunto,
        remitente,
        tipo,
        titularDe,
        fechaRecepcion,
        requiereAcuse,
        filePath,
        observaciones,
        plazoAtencion,
      ];
}

class ResetDocumentReceptionStatus extends DocumentReceptionEvent {}

class GetDocumentReceptionEvent extends DocumentReceptionEvent {
  final int id;

  const GetDocumentReceptionEvent(this.id);

  @override
  List<Object> get props => [id];
}

class DownloadDocumentFileEvent extends DocumentReceptionEvent {
  final int id;
  final String fileName;

  const DownloadDocumentFileEvent(this.id, this.fileName);

  @override
  List<Object> get props => [id, fileName];
}
