import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_reception_model.g.dart';

@JsonSerializable()
class DocumentReceptionModel extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  
  @JsonKey(name: 'tipo')
  final String tipo;
  
  @JsonKey(name: 'remitente')
  final String remitente;
  
  @JsonKey(name: 'asunto')
  final String asunto;
  
  @JsonKey(name: 'requiere_acuse')
  final bool requiereAcuse;
  
  @JsonKey(name: 'fecha_recepcion', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime fechaRecepcion;
  
  @JsonKey(name: 'titular_de')
  final String titularDe;
  
  @JsonKey(name: 'observaciones')
  final String? observaciones;
  
  @JsonKey(name: 'folio')
  final String? folio;
  
  @JsonKey(name: 'plazo_atencion')
  final int? plazoAtencion;
  
  @JsonKey(name: 'estado')
  final String? estado;
  
  @JsonKey(name: 'receptor_id')
  final int? receptorId;
  
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAt;
  
  @JsonKey(name: 'url_documento')
  final String? urlDocumento;

  const DocumentReceptionModel({
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

  // JSON serialization
  factory DocumentReceptionModel.fromJson(Map<String, dynamic> json) => 
      _$DocumentReceptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentReceptionModelToJson(this);

  // Helper methods for date time serialization
  static DateTime _dateTimeFromJson(String? dateString) {
    if (dateString == null) return DateTime.now();
    return DateTime.parse(dateString).toLocal();
  }

  static String? _dateTimeToJson(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toUtc().toIso8601String();
  }

  // Copy with method for immutability
  DocumentReceptionModel copyWith({
    int? id,
    String? tipo,
    String? remitente,
    String? asunto,
    bool? requiereAcuse,
    DateTime? fechaRecepcion,
    String? titularDe,
    String? observaciones,
    String? folio,
    int? plazoAtencion,
    String? estado,
    int? receptorId,
    DateTime? createdAt,
    String? urlDocumento,
  }) {
    return DocumentReceptionModel(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      remitente: remitente ?? this.remitente,
      asunto: asunto ?? this.asunto,
      requiereAcuse: requiereAcuse ?? this.requiereAcuse,
      fechaRecepcion: fechaRecepcion ?? this.fechaRecepcion,
      titularDe: titularDe ?? this.titularDe,
      observaciones: observaciones ?? this.observaciones,
      folio: folio ?? this.folio,
      plazoAtencion: plazoAtencion ?? this.plazoAtencion,
      estado: estado ?? this.estado,
      receptorId: receptorId ?? this.receptorId,
      createdAt: createdAt ?? this.createdAt,
      urlDocumento: urlDocumento ?? this.urlDocumento,
    );
  }

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
