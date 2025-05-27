import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Added import
import 'pdf_viewer_page.dart';

class RegistroSection extends StatefulWidget {
  final bool registroExitoso;
  final String? archivoNombre;
  final String tipoDocumento;
  final List<Map<String, String>> tiposDocumento;
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
  final ValueChanged<String?> onTipoDocumentoChanged;
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
  final ValueChanged<bool?> onNecesitaAcuseChanged;
  final ValueChanged<String> onCorreosAcuseChanged;
  final String? archivoOrigenNombre;
  final String? archivoOriginalNombre;
  final VoidCallback onSubirArchivoOrigen;
  final VoidCallback onSubirArchivoOriginal;

  const RegistroSection({
    Key? key,
    required this.registroExitoso,
    required this.archivoNombre,
    required this.tipoDocumento,
    required this.tiposDocumento,
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
    required this.archivoOrigenNombre,
    required this.archivoOriginalNombre,
    required this.onSubirArchivoOrigen,
    required this.onSubirArchivoOriginal,
  }) : super(key: key);

  @override
  State<RegistroSection> createState() => _RegistroSectionState();
}

class _RegistroSectionState extends State<RegistroSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _nomenclatura;
  late String _tipoDocumento;
  final GlobalKey<FormState> _emisionFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _recepcionFormKey = GlobalKey<FormState>();
  String _fechaRecepcion = '';
  String _plazoAtencionFecha = ''; 

  // State for RecepcionForm file
  String? _recepcionFormArchivoNombre;
  String? _recepcionFormArchivoPath;

  // Define the list of areas for the dropdown
  final List<Map<String, String>> _areasReceptorasOptions = [
    {'value': 'VAC', 'label': 'Vicerrectoría Académica'},
    {'value': 'VPR', 'label': 'Vicerrectoría de Profesionalización'},
    {'value': 'DPE', 'label': 'Dirección de Planeación y Estadística'},
    {'value': 'DJUR', 'label': 'Dirección Jurídica'},
    {'value': 'DAF', 'label': 'Dirección de Administración y Finanzas'},
    // Add other areas as needed
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _nomenclatura = widget.nomenclatura;
    _tipoDocumento = widget.tipoDocumento;
    _fechaRecepcion = widget.fechaTexto; 
    _plazoAtencionFecha = widget.plazoAtencion; 
  }

  void _onTipoDocumentoChanged(String? value) {
    if (value != null) {
      setState(() {
        _tipoDocumento = value;
        // Dynamic nomenclature generation based on document type
        final year = DateTime.now().year;
        final folio = '0013'; // Replace with actual folio logic if available
        String documentTypeCode;

        switch (value) {
          case 'Memorándum':
            documentTypeCode = 'MEM';
            break;
          case 'Oficio':
            documentTypeCode = 'OFI';
            break;
          case 'Circular':
            documentTypeCode = 'CIR';
            break;
          case 'Tarjeta Informativa':
            documentTypeCode = 'TI';
            break;
          case 'Oficio de Comisión':
            documentTypeCode = 'OC';
            break;
          case 'Documento de la Rectora':
            documentTypeCode = 'DR';
            break;
          case 'Documento Personal':
            documentTypeCode = 'DP';
            break;
          case 'Copia de Conocimiento':
            documentTypeCode = 'CC';
            break;
          default:
            documentTypeCode = 'GEN'; // Generic code for unknown types
        }

        _nomenclatura = 'UCIPS-ADM-$documentTypeCode-$year-$folio';
      });
      widget.onTipoDocumentoChanged(value);
    }
  }

  void _onFechaRecepcionTap() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fechaRecepcion = "${picked.day}/${picked.month}/${picked.year}";
      });
      // If you have a specific callback for fechaTexto or similar from the parent, call it here
      // For example: widget.onFechaTextoChanged(_fechaRecepcion);
    }
  }

  // Added handler for Plazo de Atención date picker
  void _onPlazoAtencionDateTap() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _plazoAtencionFecha = "${picked.day}/${picked.month}/${picked.year}";
      });
      widget.onPlazoAtencionChanged(_plazoAtencionFecha); // Update parent state
    }
  }

  // Method to pick file for RecepcionForm
  Future<void> _pickFileForRecepcionForm() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) { // Corrected condition: result.files.single.name is not nullable
      setState(() {
        _recepcionFormArchivoNombre = result.files.single.name;
        _recepcionFormArchivoPath = result.files.single.path; // Store path
      });
    } else {
      // User canceled the picker or an error occurred
      // Optionally, you could clear the selection:
      // setState(() {
      //   _recepcionFormArchivoNombre = null;
      //   _recepcionFormArchivoPath = null;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos la variable para aplicar estilos responsivos posteriormente
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 700;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 1000, // Ajusta este valor según tu preferencia/responsivo
          maxWidth: isWide ? 1200 : screenWidth * 0.95,  // Ajuste de ancho según pantalla
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: const [
                    Tab(text: 'Emisión de documento'),
                    Tab(text: 'Recepción de documento'),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(), // Bloquea swipe
                    children: [
                      // Emisión de documento
                      SingleChildScrollView(
                        child: _EmisionForm(
                          registroExitoso: widget.registroExitoso,
                          archivoNombre: widget.archivoNombre, // This is for Emision
                          tipoDocumento: _tipoDocumento,
                          tiposDocumento: widget.tiposDocumento,
                          asunto: widget.asunto,
                          area: widget.area,
                          solicitante: widget.solicitante,
                          nomenclatura: _nomenclatura,
                          fechaTexto: widget.fechaTexto,
                          dirigidoA: widget.dirigidoA,
                          observaciones: widget.observaciones,
                          enRespuestaA: widget.enRespuestaA,
                          formKey: _emisionFormKey,
                          onTipoDocumentoChanged: _onTipoDocumentoChanged,
                          onAsuntoChanged: widget.onAsuntoChanged,
                          onAreaChanged: widget.onAreaChanged,
                          onSolicitanteChanged: widget.onSolicitanteChanged,
                          onSubirArchivo: widget.onSubirArchivo, // This is for Emision
                          onRegistrar: widget.onRegistrar,
                          onFechaTap: widget.onFechaTap,
                          onDirigidoAChanged: widget.onDirigidoAChanged,
                          onObservacionesChanged: widget.onObservacionesChanged,
                          onEnRespuestaAChanged: widget.onEnRespuestaAChanged,
                          onAcuseChanged: widget.onAcuseChanged,
                          archivoOrigenNombre: widget.archivoOrigenNombre,
                          archivoOriginalNombre: widget.archivoOriginalNombre,
                          onSubirArchivoOrigen: widget.onSubirArchivoOrigen,
                          onSubirArchivoOriginal: widget.onSubirArchivoOriginal,
                        ),
                      ),
                      // Recepción de documento
                      SingleChildScrollView(
                        child: _RecepcionForm(
                          registroExitoso: widget.registroExitoso,
                          archivoNombre: _recepcionFormArchivoNombre, // Use state for Recepcion form
                          archivoPath: _recepcionFormArchivoPath, // Pass path for preview
                          remitente: widget.remitente,
                          titularDe: widget.titularDe,
                          asunto: widget.asunto,
                          area: widget.area, 
                          areasReceptoras: _areasReceptorasOptions, 
                          fechaRecepcionTexto: _fechaRecepcion, // Pass correct date text
                          plazoAtencion: _plazoAtencionFecha, 
                          necesitaAcuse: widget.necesitaAcuse,
                          correosAcuse: widget.correosAcuse,
                          formKey: _recepcionFormKey, 
                          onRemitenteChanged: widget.onRemitenteChanged,
                          onTitularDeChanged: widget.onTitularDeChanged,
                          onAsuntoChanged: widget.onAsuntoChanged,
                          onAreaChanged: widget.onAreaChanged,
                          onPlazoAtencionChanged: widget.onPlazoAtencionChanged,
                          onSubirArchivo: _pickFileForRecepcionForm, // Use new handler
                          onRegistrar: () {
                            if (_recepcionFormKey.currentState!.validate()) {
                              widget.onRegistrar();
                            }
                          },
                          onFechaTap: _onFechaRecepcionTap, 
                          onPlazoAtencionDateTap: _onPlazoAtencionDateTap, 
                          onNecesitaAcuseChanged: widget.onNecesitaAcuseChanged,
                          onCorreosAcuseChanged: widget.onCorreosAcuseChanged,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Emisión de documento
class _EmisionForm extends StatelessWidget {
  final bool registroExitoso;
  final String? archivoNombre;
  final String tipoDocumento;
  final List<Map<String, String>> tiposDocumento;
  final String asunto;
  final String area;
  final String solicitante;
  final String nomenclatura;
  final String fechaTexto;
  final String dirigidoA;
  final String observaciones;
  final String enRespuestaA;
  final GlobalKey<FormState> formKey;
  final ValueChanged<String?> onTipoDocumentoChanged;
  final ValueChanged<String> onAsuntoChanged;
  final ValueChanged<String> onAreaChanged;
  final ValueChanged<String> onSolicitanteChanged;
  final ValueChanged<bool> onAcuseChanged;
  final VoidCallback onSubirArchivo;
  final VoidCallback onRegistrar;
  final VoidCallback onFechaTap;
  final ValueChanged<String> onDirigidoAChanged;
  final ValueChanged<String> onObservacionesChanged;
  final ValueChanged<String> onEnRespuestaAChanged;
  final String? archivoOrigenNombre;
  final String? archivoOriginalNombre;
  final VoidCallback onSubirArchivoOrigen;
  final VoidCallback onSubirArchivoOriginal;

  const _EmisionForm({
    required this.registroExitoso,
    required this.archivoNombre,
    required this.tipoDocumento,
    required this.tiposDocumento,
    required this.asunto,
    required this.area,
    required this.solicitante,
    required this.nomenclatura,
    required this.fechaTexto,
    required this.dirigidoA,
    required this.observaciones,
    required this.enRespuestaA,
    required this.formKey,
    required this.onTipoDocumentoChanged,
    required this.onAsuntoChanged,
    required this.onAreaChanged,
    required this.onSolicitanteChanged,
    required this.onSubirArchivo,
    required this.onRegistrar,
    required this.onFechaTap,
    required this.onDirigidoAChanged,
    required this.onObservacionesChanged,
    required this.onEnRespuestaAChanged,
    required this.onAcuseChanged,
    required this.archivoOrigenNombre,
    required this.archivoOriginalNombre,
    required this.onSubirArchivoOrigen,
    required this.onSubirArchivoOriginal,
  });

  @override
  Widget build(BuildContext context) {
    final nomenclaturaController = TextEditingController(text: nomenclatura);
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Emisión de documento', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // 1. NOMENCLATURA
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nomenclatura'),
              readOnly: true,
              controller: nomenclaturaController,
            ),
            const SizedBox(height: 12),
            // 2. TIPO DE DOCUMENTO
            DropdownButtonFormField<String>(
              value: const [
                'Memorándum',
                'Oficio',
                'Circular',
                'Tarjeta Informativa',
                'Oficio de Comisión',
                'Documento de la Rectora',
                'Documento Personal',
                'Copia de Conocimiento',
              ].contains(tipoDocumento)
                  ? tipoDocumento
                  : null, // Ensure value matches one of the items or defaults to null
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Tipo de Documento',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              items: const [
                DropdownMenuItem(value: 'Memorándum', child: Text('Memorándum')),
                DropdownMenuItem(value: 'Oficio', child: Text('Oficio')),
                DropdownMenuItem(value: 'Circular', child: Text('Circular')),
                DropdownMenuItem(value: 'Tarjeta Informativa', child: Text('Tarjeta Informativa')),
                DropdownMenuItem(value: 'Oficio de Comisión', child: Text('Oficio de Comisión')),
                DropdownMenuItem(value: 'Documento de la Rectora', child: Text('Documento de la Rectora')),
                DropdownMenuItem(value: 'Documento Personal', child: Text('Documento Personal')),
                DropdownMenuItem(value: 'Copia de Conocimiento', child: Text('Copia de Conocimiento')),
              ],
              onChanged: onTipoDocumentoChanged,
            ),
            const SizedBox(height: 12),
            // 3. ARCHIVO DE ORIGEN (PDF obligatorio)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Documento recibido', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.file_upload_outlined),
                    label: Row(
                      children: [
                        Text(
                          archivoOrigenNombre != null && archivoOrigenNombre!.isNotEmpty
                              ? 'Archivo seleccionado'
                              : 'Seleccionar archivo PDF',
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (archivoOrigenNombre != null && archivoOrigenNombre!.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.check, size: 14),
                                SizedBox(width: 2),
                                Text('OK', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: Colors.blue[700], // Azul UCIPS mejorado
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.blue[900]!.withOpacity(0.3)),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onSubirArchivoOrigen,
                  ),
                ),
                if (archivoOrigenNombre != null && archivoOrigenNombre!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.source_outlined, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            archivoOrigenNombre!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          iconSize: 20,
                          icon: Icon(Icons.visibility, color: Colors.blue[700]),
                          tooltip: 'Vista previa PDF',
                          onPressed: () {
                            // Implementar vista previa PDF usando PdfViewerPage
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PdfViewerPage(
                                  pdfPathOrUrl: 'https://example.com/sample.pdf', // Placeholder URL hasta que tengamos URL real
                                  title: 'Archivo de Origen',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            // 3. ARCHIVO ORIGINAL (PDF obligatorio)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Archivo original (PDF obligatorio)', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.file_upload_outlined),
                    label: Row(
                      children: [
                        Text(
                          archivoOriginalNombre != null && archivoOriginalNombre!.isNotEmpty
                              ? 'Archivo seleccionado'
                              : 'Seleccionar archivo PDF',
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (archivoOriginalNombre != null && archivoOriginalNombre!.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.check, size: 14),
                                SizedBox(width: 2),
                                Text('OK', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: Colors.red[700], // Rojo para archivo original mejorado
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.red[900]!.withOpacity(0.3)),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onSubirArchivoOriginal,
                  ),
                ),
                if (archivoOriginalNombre != null && archivoOriginalNombre!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.description_outlined, color: Colors.red[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            archivoOriginalNombre!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          iconSize: 20,
                          icon: Icon(Icons.visibility, color: Colors.red[700]),
                          tooltip: 'Vista previa PDF',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PdfViewerPage(
                                  pdfPathOrUrl: 'https://example.com/sample.pdf', // Placeholder URL hasta que tengamos URL real
                                  title: 'Archivo Original',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // 4. FECHA DE ELABORACIÓN
            GestureDetector(
              onTap: onFechaTap,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de elaboración',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  controller: TextEditingController(text: fechaTexto),
                  validator: (v) => v == null || v.isEmpty ? 'Seleccione la fecha' : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 5. DIRIGIDO A
            TextFormField(
              decoration: const InputDecoration(labelText: 'Dirigido a'),
              onChanged: onDirigidoAChanged,
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            // 6. ASUNTO
            TextFormField(
              decoration: const InputDecoration(labelText: 'Asunto'),
              onChanged: onAsuntoChanged,
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            // 7. ÁREA SOLICITANTE
            DropdownButtonFormField<String>(
              value: const ['VAC', 'VPR', 'DPE', 'DJUR', 'DAF'].contains(area) ? area : null,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Área Solicitante',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              items: const [
                DropdownMenuItem(value: 'VAC', child: Text('Vicerrectoría Académica')),
                DropdownMenuItem(value: 'VPR', child: Text('Vicerrectoría de Profesionalización')),
                DropdownMenuItem(value: 'DPE', child: Text('Dirección de Planeación y Estadística')),
                DropdownMenuItem(value: 'DJUR', child: Text('Dirección Jurídica')),
                DropdownMenuItem(value: 'DAF', child: Text('Dirección de Administración y Finanzas')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onAreaChanged(newValue);
                }
              },
            ),
            const SizedBox(height: 12),
            // 8. ¿QUIÉN LO SOLICITÓ?
            TextFormField(
              decoration: const InputDecoration(labelText: '¿Quién lo solicitó?'),
              onChanged: onSolicitanteChanged,
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            // 9. OBSERVACIONES
            TextFormField(
              decoration: const InputDecoration(labelText: 'Observaciones (opcional)'),
              maxLines: 3,
              onChanged: onObservacionesChanged,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onRegistrar,
                child: const Text('Registrar documento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Recepción de documento
class _RecepcionForm extends StatelessWidget {
  final bool registroExitoso;
  final String? archivoNombre;
  final String? archivoPath; // Added for preview
  final String remitente;
  final String titularDe;
  final String asunto;
  final String area;
  final List<Map<String, String>> areasReceptoras; 
  final String fechaRecepcionTexto; // Added for correct date display
  final String plazoAtencion;
  final bool necesitaAcuse;
  final String correosAcuse;
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onRemitenteChanged;
  final ValueChanged<String> onTitularDeChanged;
  final ValueChanged<String> onAsuntoChanged;
  final ValueChanged<String> onAreaChanged;
  final ValueChanged<String> onPlazoAtencionChanged;
  final VoidCallback onSubirArchivo;
  final VoidCallback onRegistrar;
  final VoidCallback onFechaTap;
  final VoidCallback onPlazoAtencionDateTap; 
  final ValueChanged<bool?> onNecesitaAcuseChanged;
  final ValueChanged<String> onCorreosAcuseChanged;

  const _RecepcionForm({
    required this.registroExitoso,
    required this.archivoNombre,
    this.archivoPath, // Added for preview
    required this.remitente,
    required this.titularDe,
    required this.asunto,
    required this.area,
    required this.areasReceptoras, 
    required this.fechaRecepcionTexto, // Added for correct date display
    required this.plazoAtencion,
    required this.necesitaAcuse,
    required this.correosAcuse,
    required this.formKey,
    required this.onRemitenteChanged,
    required this.onTitularDeChanged,
    required this.onAsuntoChanged,
    required this.onAreaChanged,
    required this.onPlazoAtencionChanged,
    required this.onSubirArchivo,
    required this.onRegistrar,
    required this.onFechaTap,
    required this.onPlazoAtencionDateTap, 
    required this.onNecesitaAcuseChanged,
    required this.onCorreosAcuseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recepción de documento', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onFechaTap, 
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de recepción',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  controller: TextEditingController(text: fechaRecepcionTexto), // Corrected controller
                  validator: (v) => v == null || v.isEmpty ? 'Seleccione la fecha' : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Remitente'),
              onChanged: onRemitenteChanged,
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Titular de'),
              onChanged: onTitularDeChanged,
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Asunto'),
              onChanged: onAsuntoChanged,
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: areasReceptoras.any((map) => map['value'] == area) ? area : null,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Área receptora',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              items: areasReceptoras.map((areaMap) => 
                DropdownMenuItem(value: areaMap['value'], child: Text(areaMap['label']!))
              ).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onAreaChanged(newValue);
                }
              },
              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            GestureDetector( 
              onTap: onPlazoAtencionDateTap, 
              child: AbsorbPointer( 
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Plazo de atención',
                    suffixIcon: Icon(Icons.calendar_today), 
                  ),
                  readOnly: true, 
                  controller: TextEditingController(text: plazoAtencion), 
                  validator: (v) => v == null || v.isEmpty ? 'Seleccione la fecha' : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Campo de selección de archivo PDF (ancho igual a los campos)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.file_upload_outlined),
                label: Text(
                  archivoNombre != null && archivoNombre!.isNotEmpty
                      ? archivoNombre!
                      : 'Seleccionar archivo PDF',
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.amber[900]!.withOpacity(0.3)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: onSubirArchivo,
              ),
            ),
            if (archivoNombre != null && archivoNombre!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.amber[900], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        archivoNombre!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      iconSize: 20,
                      icon: Icon(Icons.visibility, color: Colors.amber[900]),
                      tooltip: 'Vista previa PDF',
                      onPressed: archivoPath != null && archivoPath!.isNotEmpty
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PdfViewerPage(
                                    pdfPathOrUrl: archivoPath!, // Use the actual path
                                    // Assuming PdfViewerPage can handle local paths.
                                    // May need an 'isNetwork: false' or similar if it's ambiguous.
                                    title: 'Vista Previa PDF',
                                  ),
                                ),
                              );
                            }
                          : null, // Disable button if no path
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('¿Requiere acuse?'),
              value: necesitaAcuse,
              onChanged: onNecesitaAcuseChanged,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (necesitaAcuse)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Correos destino (separados por comas)',
                ),
                onChanged: onCorreosAcuseChanged,
                validator: (v) => (necesitaAcuse && (v == null || v.isEmpty)) ? 'Campo obligatorio si requiere acuse' : null,
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onRegistrar,
                child: const Text('Registrar documento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sección de perfil de usuario
class PerfilSection extends StatefulWidget {
  final String nombre;
  final String correo;
  final Color colorPrimario;
  final ValueChanged<String> onNombreChanged;
  final ValueChanged<String> onCorreoChanged;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onGuardar;

  const PerfilSection({
    super.key,
    required this.nombre,
    required this.correo,
    required this.colorPrimario,
    required this.onNombreChanged,
    required this.onCorreoChanged,
    required this.onColorChanged,
    required this.onGuardar,
  });

  @override
  State<PerfilSection> createState() => _PerfilSectionState();
}

class _PerfilSectionState extends State<PerfilSection> {
  late TextEditingController _nombreController;
  late TextEditingController _correoController;
  late Color _colorSeleccionado;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre);
    _correoController = TextEditingController(text: widget.correo);
    _colorSeleccionado = widget.colorPrimario;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perfil de usuario', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              onChanged: widget.onNombreChanged,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _correoController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              onChanged: widget.onCorreoChanged,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Color primario:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    final Color? color = await showDialog(
                      context: context,
                      builder: (context) => _ColorPickerDialog(color: _colorSeleccionado),
                    );
                    if (color != null) {
                      setState(() => _colorSeleccionado = color);
                      widget.onColorChanged(color);
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _colorSeleccionado,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
                onPressed: widget.onGuardar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPickerDialog extends StatelessWidget {
  final Color color;
  const _ColorPickerDialog({required this.color});

  @override
  Widget build(BuildContext context) {
    final List<Color> colores = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.pink, Colors.brown
    ];
    return AlertDialog(
      title: const Text('Selecciona un color'),
      content: Wrap(
        spacing: 12,
        children: colores.map((c) => GestureDetector(
          onTap: () => Navigator.of(context).pop(c),
          child: Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: c == color ? Colors.black : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        )).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
