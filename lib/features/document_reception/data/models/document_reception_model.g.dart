// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_reception_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentReceptionModel _$DocumentReceptionModelFromJson(
        Map<String, dynamic> json) =>
    DocumentReceptionModel(
      id: (json['id'] as num?)?.toInt(),
      tipo: json['tipo'] as String,
      remitente: json['remitente'] as String,
      asunto: json['asunto'] as String,
      requiereAcuse: json['requiere_acuse'] as bool,
      fechaRecepcion: DocumentReceptionModel._dateTimeFromJson(
          json['fecha_recepcion'] as String?),
      titularDe: json['titular_de'] as String,
      observaciones: json['observaciones'] as String?,
      folio: json['folio'] as String?,
      plazoAtencion: (json['plazo_atencion'] as num?)?.toInt(),
      estado: json['estado'] as String?,
      receptorId: (json['receptor_id'] as num?)?.toInt(),
      createdAt: DocumentReceptionModel._dateTimeFromJson(
          json['created_at'] as String?),
      urlDocumento: json['url_documento'] as String?,
    );

Map<String, dynamic> _$DocumentReceptionModelToJson(
        DocumentReceptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tipo': instance.tipo,
      'remitente': instance.remitente,
      'asunto': instance.asunto,
      'requiere_acuse': instance.requiereAcuse,
      'fecha_recepcion':
          DocumentReceptionModel._dateTimeToJson(instance.fechaRecepcion),
      'titular_de': instance.titularDe,
      'observaciones': instance.observaciones,
      'folio': instance.folio,
      'plazo_atencion': instance.plazoAtencion,
      'estado': instance.estado,
      'receptor_id': instance.receptorId,
      'created_at': DocumentReceptionModel._dateTimeToJson(instance.createdAt),
      'url_documento': instance.urlDocumento,
    };
