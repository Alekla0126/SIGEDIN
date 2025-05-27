import 'package:equatable/equatable.dart';

class CreateDocumentReceptionParams extends Equatable {
  final String tipo;
  final String remitente;
  final String asunto;
  final bool requiereAcuse;
  final String fechaRecepcion;
  final String titularDe;
  final String? observaciones;
  final int? plazoAtencion;
  final String filePath;

  const CreateDocumentReceptionParams({
    required this.tipo,
    required this.remitente,
    required this.asunto,
    required this.requiereAcuse,
    required this.fechaRecepcion,
    required this.titularDe,
    this.observaciones,
    this.plazoAtencion,
    required this.filePath,
  });

  @override
  List<Object?> get props => [
        tipo,
        remitente,
        asunto,
        requiereAcuse,
        fechaRecepcion,
        titularDe,
        observaciones,
        plazoAtencion,
        filePath,
      ];

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'remitente': remitente,
        'asunto': asunto,
        'requiere_acuse': requiereAcuse,
        'fecha_recepcion': fechaRecepcion,
        'titular_de': titularDe,
        if (observaciones != null) 'observaciones': observaciones,
        if (plazoAtencion != null) 'plazo_atencion': plazoAtencion,
        'file_path': filePath,
      };
}
