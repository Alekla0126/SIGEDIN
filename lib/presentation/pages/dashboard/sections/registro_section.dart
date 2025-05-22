import 'package:flutter/material.dart';

class RegistroSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
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
  final Function(String) onTipoDocumentoChanged;
  final Function(String) onAsuntoChanged;
  final Function(String) onAreaChanged;
  final Function(String) onSolicitanteChanged;
  final Function(bool) onAcuseChanged;
  final VoidCallback onSubirArchivo;
  final VoidCallback onRegistrar;
  final VoidCallback onFechaTap;
  final VoidCallback onPlazoDeTap;
  final Function(String) onDirigidoAChanged;
  final Function(String) onObservacionesChanged;
  final Function(String) onEnRespuestaAChanged;
  final Function(String) onRemitenteChanged;
  final Function(String) onTitularDeChanged;
  final Function(String) onPlazoAtencionChanged;
  final Function(bool) onNecesitaAcuseChanged;
  final Function(String) onCorreosAcuseChanged;

  const RegistroSection({
    Key? key,
    required this.formKey,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      physics: const ClampingScrollPhysics(),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width > 800
              ? 600.0
              : MediaQuery.of(context).size.width * 0.92,
          constraints: const BoxConstraints(
            minWidth: 300,
            minHeight: 100,
          ),
          child: Card(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              minimum: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add your form fields and widgets here
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
