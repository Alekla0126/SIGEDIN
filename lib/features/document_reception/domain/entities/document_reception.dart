import 'package:equatable/equatable.dart';

class DocumentReception extends Equatable {
  final int? id;
  final String tipo;
  final String remitente;
  final String asunto;
  final bool requiereAcuse;
  final DateTime fechaRecepcion;
  final String titularDe;
  final String? observaciones;
  final String? folio;
  final int? plazoAtencion;
  final String? estado;
  final int? receptorId;
  final DateTime? createdAt;
  final String? urlDocumento;

  const DocumentReception({
    this.id,
    required this.tipo,
    required this.remitente,
    required this.asunto,
    required this.requiereAcuse,
    required this.fechaRecepcion,
    required this.titularDe,
    this.observaciones,
    this.folio,
    this.plazoAtencion,
    this.estado,
    this.receptorId,
    this.createdAt,
    this.urlDocumento,
  });

  @override
  List<Object?> get props => [
        id,
        tipo,
        remitente,
        asunto,
        requiereAcuse,
        fechaRecepcion,
        titularDe,
        observaciones,
        folio,
        plazoAtencion,
        estado,
        receptorId,
        createdAt,
        urlDocumento,
      ];
}
