import 'package:flutter/material.dart';
import 'reusable_widget.dart';

class RegistroDocumentoForm extends StatelessWidget {
  final bool registroExitoso;
  final String? archivoNombre;
  final String tipoDocumento;
  final String asunto;
  final String area;
  final String solicitante;
  final bool acuse;
  final String nomenclatura;
  final String fechaTexto;
  final String dirigidoA;
  final String observaciones;
  final String enRespuestaA;
  final String remitente;
  final String titularDe;
  final String plazoAtencion;
  final bool necesitaAcuse;
  final String correosAcuse;
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onTipoDocumentoChanged;
  final ValueChanged<String> onAsuntoChanged;
  final ValueChanged<String> onAreaChanged;
  final ValueChanged<String> onSolicitanteChanged;
  final ValueChanged<bool> onAcuseChanged;
  final VoidCallback onSubirArchivo;
  final VoidCallback onRegistrar;
  final VoidCallback onFechaTap;
  final VoidCallback onPlazoDeTap;
  final ValueChanged<String> onDirigidoAChanged;
  final ValueChanged<String> onObservacionesChanged;
  final ValueChanged<String> onEnRespuestaAChanged;
  final ValueChanged<String> onRemitenteChanged;
  final ValueChanged<String> onTitularDeChanged;
  final ValueChanged<String> onPlazoAtencionChanged;
  final ValueChanged<bool> onNecesitaAcuseChanged;
  final ValueChanged<String> onCorreosAcuseChanged;

  const RegistroDocumentoForm({
    Key? key,
    required this.registroExitoso,
    required this.archivoNombre,
    required this.tipoDocumento,
    required this.asunto,
    required this.area,
    required this.solicitante,
    required this.acuse,
    required this.nomenclatura,
    required this.fechaTexto,
    required this.dirigidoA,
    required this.observaciones,
    required this.enRespuestaA,
    required this.remitente,
    required this.titularDe,
    required this.plazoAtencion,
    required this.necesitaAcuse,
    required this.correosAcuse,
    required this.formKey,
    required this.onTipoDocumentoChanged,
    required this.onAsuntoChanged,
    required this.onAreaChanged,
    required this.onSolicitanteChanged,
    required this.onAcuseChanged,
    required this.onSubirArchivo,
    required this.onRegistrar,
    required this.onFechaTap,
    required this.onPlazoDeTap,
    required this.onDirigidoAChanged,
    required this.onObservacionesChanged,
    required this.onEnRespuestaAChanged,
    required this.onRemitenteChanged,
    required this.onTitularDeChanged,
    required this.onPlazoAtencionChanged,
    required this.onNecesitaAcuseChanged,
    required this.onCorreosAcuseChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ...existing code from _RegistroDocumentoForm.build...
    // (El contenido del método build se debe copiar aquí desde el widget original)
    return Container(); // Placeholder temporal
  }
}
