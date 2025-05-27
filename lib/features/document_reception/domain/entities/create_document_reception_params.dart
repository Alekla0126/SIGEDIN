import 'package:equatable/equatable.dart';

class CreateDocumentReceptionParams extends Equatable {
  final String asunto;
  final String remitente;
  final String tipo;
  final String titularDe;
  final DateTime fechaRecepcion;
  final bool requiereAcuse;
  final String filePath;
  final String? observaciones;
  final int? plazoAtencion;

  const CreateDocumentReceptionParams({
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
