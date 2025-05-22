import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_viewer_page.dart';

class ConsultaSection extends StatelessWidget {
  final List<Map<String, String>> documentos;
  final String filtroTipoDoc;
  final String filtroAreaDoc;
  final String filtroEstatusDoc;
  final String busquedaDoc;
  final ValueChanged<String> onBusquedaChanged;
  final ValueChanged<String?> onFiltroTipoChanged;
  final ValueChanged<String?> onFiltroAreaChanged;
  final ValueChanged<String?> onFiltroEstatusChanged;
  final VoidCallback onTurnar;
  final VoidCallback onAcuse;

  const ConsultaSection({
    Key? key,
    required this.documentos,
    required this.filtroTipoDoc,
    required this.filtroAreaDoc,
    required this.filtroEstatusDoc,
    required this.busquedaDoc,
    required this.onBusquedaChanged,
    required this.onFiltroTipoChanged,
    required this.onFiltroAreaChanged,
    required this.onFiltroEstatusChanged,
    required this.onTurnar,
    required this.onAcuse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const Tab(text: 'Emitidos'),
      const Tab(text: 'Recibidos'),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Consulta de Documentos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TabBar(
            tabs: tabs,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue,
            onTap: (index) {
              onFiltroTipoChanged('Todos');
              onFiltroAreaChanged('Todos');
              onFiltroEstatusChanged('Todos');
              onBusquedaChanged('');
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildConsultaTabla(context, 'Salida', false, false),
                _buildConsultaTabla(context, 'Entrada', true, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultaTabla(BuildContext context, String tipoFiltro, bool mostrarTurnar, bool mostrarAcuse) {
    // Mapa oficial de tipos de documento: código y nombre
    const tiposDocumento = [
      {'codigo': 'MEM', 'nombre': 'Memorándum'},
      {'codigo': 'OF', 'nombre': 'Oficio'},
      {'codigo': 'CIR', 'nombre': 'Circular'},
      {'codigo': 'TI', 'nombre': 'Tarjeta Informativa'},
      {'codigo': 'OC', 'nombre': 'Oficio de Comisión'},
      {'codigo': 'PER', 'nombre': 'Documento Personal'},
      {'codigo': 'REC', 'nombre': 'Documento de la Rectora'},
      {'codigo': 'PAP', 'nombre': 'Papeleta'},
      {'codigo': 'CC', 'nombre': 'Copia de Conocimiento'},
    ];

    // Definir tipos válidos para cada pestaña
    const tiposEntrada = ['MEM', 'OC'];
    const tiposSalida = ['OF'];

    final docsTipo = documentos.where((doc) {
      if (tipoFiltro == 'Entrada') {
        return tiposEntrada.contains(doc['tipo']);
      } else {
        return tiposSalida.contains(doc['tipo']);
      }
    }).toList();

    // Filtros de tipo solo con los tipos válidos y mostrando nombre
    final tiposValidos = tipoFiltro == 'Entrada' ? tiposEntrada : tiposSalida;
    final tipos = [
      {'codigo': 'Todos', 'nombre': 'Todos'},
      ...tiposDocumento.where((t) => tiposValidos.contains(t['codigo']))
    ];
    final areas = ['Todos', ...{for (var d in docsTipo) d['area'] ?? ''}..removeWhere((e) => e.isEmpty)];
    final estatuses = ['Todos', ...{for (var d in docsTipo) d['estatus'] ?? ''}..removeWhere((e) => e.isEmpty)];

    // Buscar el código seleccionado
    final tipoValue = tipos.any((t) => t['codigo'] == filtroTipoDoc) ? filtroTipoDoc : 'Todos';
    final areaValue = areas.contains(filtroAreaDoc) ? filtroAreaDoc : 'Todos';
    final estatusValue = estatuses.contains(filtroEstatusDoc) ? filtroEstatusDoc : 'Todos';

    final docsFiltrados = docsTipo.where((doc) {
      final coincideTipo = tipoValue == 'Todos' || doc['tipo'] == tipoValue;
      final coincideArea = areaValue == 'Todos' || doc['area'] == areaValue;
      final coincideEstatus = estatusValue == 'Todos' || doc['estatus'] == estatusValue;
      final coincideBusqueda = busquedaDoc.isEmpty || 
        (doc['asunto']?.toLowerCase().contains(busquedaDoc.toLowerCase()) ?? false) || 
        (doc['area']?.toLowerCase().contains(busquedaDoc.toLowerCase()) ?? false) || 
        (doc['tipo']?.toLowerCase().contains(busquedaDoc.toLowerCase()) ?? false);
      return coincideTipo && coincideArea && coincideEstatus && coincideBusqueda;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        if (isMobile) {
          // MOBILE: Use Card/ListTile view for each document
          return Expanded(
            child: docsFiltrados.isEmpty
                ? const Center(child: Text('No hay documentos para mostrar.'))
                : ListView.separated(
                    itemCount: docsFiltrados.length,
                    separatorBuilder: (context, i) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final doc = docsFiltrados[i];
                      final isSalida = tipoFiltro == 'Salida';
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      doc['nomenclatura'] ?? '-',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isSalida)
                                    IconButton(
                                      icon: const Icon(Icons.send, color: Colors.blue),
                                      tooltip: 'Turnar',
                                      onPressed: () async {
                                        final emailController = TextEditingController();
                                        String? errorText;
                                        await showDialog<String>(
                                          context: context,
                                          builder: (context) => StatefulBuilder(
                                            builder: (context, setState) => AlertDialog(
                                              title: const Text('Turnar documento'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: emailController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Correos electrónicos destinatarios',
                                                      hintText: 'correo1@ucips.edu.mx, correo2@ucips.edu.mx',
                                                      errorText: errorText,
                                                    ),
                                                    keyboardType: TextInputType.emailAddress,
                                                    autofocus: true,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text('Separe los correos con coma.', style: TextStyle(fontSize: 12)),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: const Text('Cancelar'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    final emails = emailController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                                                    // Corregir la expresión regular
                                                    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                                    final invalids = emails.where((e) => !emailRegExp.hasMatch(e)).toList();
                                                    if (emails.isEmpty || invalids.isNotEmpty) {
                                                      setState(() {
                                                        errorText = invalids.isNotEmpty
                                                          ? 'Correos inválidos: ${invalids.join(", ")}'
                                                          : 'Ingrese al menos un correo válido.';
                                                      });
                                                      return;
                                                    }
                                                    Navigator.of(context).pop(emailController.text);
                                                  },
                                                  child: const Text('Turnar'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                        if (emailController.text.isNotEmpty && errorText == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Documento turnado a \\n${emailController.text}. Esperando acuse...')),
                                          );
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                    tooltip: isSalida ? 'Ver PDF' : 'Ver documento original',
                                    onPressed: () {
                                      final pdfUrl = doc['pdfUrl'] ?? '';
                                      if (pdfUrl.isNotEmpty) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PdfViewerPage(
                                              pdfPathOrUrl: pdfUrl,
                                              title: doc['nomenclatura'] ?? 'Documento PDF',
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No hay PDF disponible para este documento.')),
                                        );
                                      }
                                    },
                                  ),
                                  if (!isSalida)
                                    IconButton(
                                      icon: const Icon(Icons.description, color: Colors.green),
                                      tooltip: 'Ver papeleta',
                                      onPressed: () {
                                        final papeletaUrl = doc['papeletaUrl'] ?? '';
                                        if (papeletaUrl.isNotEmpty) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PdfViewerPage(
                                                pdfPathOrUrl: papeletaUrl,
                                                title: 'Papeleta - ${doc['nomenclatura'] ?? ''}',
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('No hay papeleta disponible para este documento.')),
                                          );
                                        }
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 10,
                                runSpacing: 2,
                                children: [
                                  _docField('Fecha', isSalida ? doc['fechaElaboracion'] : doc['fechaRecepcion']),
                                  if (isSalida)
                                    _docField('Dirigido a', doc['dirigidoA'])
                                  else
                                    _docField('Remitente', doc['remitente']),
                                  _docField('Tipo', doc['tipo']),
                                  _docField('Cargo', doc['cargo']),
                                  _docField('Área', doc['area']),
                                  _docField('Asunto', doc['asunto']),
                                  _docField('Copias', doc['copias']),
                                  _docField('Respuesta', doc['respuesta']),
                                ].where((w) => w != null).toList() as List<Widget>,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        }
        // DESKTOP/TABLET: DataTable as before
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Buscar',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          onChanged: onBusquedaChanged,
                          controller: TextEditingController(text: busquedaDoc),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          value: tipoValue,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Tipo',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          items: tipos.map((t) => DropdownMenuItem(value: t['codigo'] as String, child: Text(t['nombre'] as String))).toList(),
                          onChanged: onFiltroTipoChanged,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          value: areaValue,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Área',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          items: areas.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                          onChanged: onFiltroAreaChanged,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          value: estatusValue,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Estatus',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          items: estatuses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: onFiltroEstatusChanged,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Buscar',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          onChanged: onBusquedaChanged,
                          controller: TextEditingController(text: busquedaDoc),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: tipoValue,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Tipo',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          items: tipos.map((t) => DropdownMenuItem(value: t['codigo'] as String, child: Text(t['nombre'] as String, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: onFiltroTipoChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: areaValue,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Área',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          items: areas.map((a) => DropdownMenuItem(value: a, child: Text(a, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: onFiltroAreaChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: estatusValue,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Estatus',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          items: estatuses.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: onFiltroEstatusChanged,
                        ),
                      ),
                    ],
                  ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: isMobile ? 600 : constraints.maxWidth),
                    child: SizedBox(
                      width: constraints.maxWidth, // Make table fit available width
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.resolveWith<Color?>((states) => Colors.blue[100]),
                        dataRowColor: MaterialStateProperty.resolveWith<Color?>((states) {
                          // Simplifiquemos esta lógica para evitar errores
                          if (states.contains(MaterialState.selected)) {
                            return Colors.blue[50];
                          }
                          return null; // Usaremos la coloración en la generación de filas
                        }),
                        columnSpacing: 8, // Reduce spacing
                        dataRowHeight: 44, // Reduce row height
                        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87), // Smaller font
                        dataTextStyle: const TextStyle(fontSize: 12), // Smaller font for cells
                        columns: tipoFiltro == 'Salida' ?
                          [
                            const DataColumn(label: Center(child: Text('NOMENCLATURA'))),
                            const DataColumn(label: Center(child: Text('ACUSE'))),
                            const DataColumn(label: Center(child: Text('ARCHIVO DE\nORIGEN'))),
                            const DataColumn(label: Center(child: Text('ARCHIVO\nORIGINAL'))),
                            const DataColumn(label: Center(child: Text('ARCHIVO\nACUSE'))),
                            const DataColumn(label: Center(child: Text('NOMENCLATURA'))),
                            const DataColumn(label: Center(child: Text('FECHA DE\nELABORACIÓN'))),
                            const DataColumn(label: Center(child: Text('DIRIGIDO A'))),
                            const DataColumn(label: Center(child: Text('ASUNTO'))),
                            const DataColumn(label: Center(child: Text('ÁREA\nSOLICITANTE'))),
                            const DataColumn(label: Center(child: Text('¿QUIÉN LO\nSOLICITÓ?'))),
                            const DataColumn(label: Center(child: Text('OBSERVACIONES'))),
                          ] :
                          [
                            const DataColumn(label: Center(child: Text('NOMENCLATURA'))),
                            const DataColumn(label: Center(child: Text('FECHA DE\nRECEPCIÓN'))),
                            const DataColumn(label: Center(child: Text('REMITENTE'))),
                            const DataColumn(label: Center(child: Text('CARGO'))),
                            const DataColumn(label: Center(child: Text('ASUNTO'))),
                            const DataColumn(label: Center(child: Text('ÁREA'))),
                            const DataColumn(label: Center(child: Text('COPIAS'))),
                            const DataColumn(label: Center(child: Text('RESPUESTA'))),
                            const DataColumn(label: Center(child: Text('ARCHIVO\nORIGINAL'))),
                            const DataColumn(label: Center(child: Text('PAPELETA'))),
                            const DataColumn(label: Center(child: Text('REQUIERE\nACUSE'))),
                            const DataColumn(label: Center(child: Text('OBSERVACIONES'))),
                          ],
                        rows: docsFiltrados.asMap().entries.map((entry) {
                          final i = entry.key;
                          final doc = entry.value;
                          if (tipoFiltro == 'Salida') {
                            List<DataCell> cells = [];
                            cells.add(DataCell(Tooltip(message: doc['nomenclatura'] ?? '-', child: Text(doc['nomenclatura'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // NOMENCLATURA
                            cells.add(DataCell(Center(child: _booleanCell(doc['acuse'], trueText: 'RECIBIDO', falseText: 'PENDIENTE', trueColor: Colors.green[700], falseColor: Colors.orange[700])))); // ACUSE
                            cells.add(DataCell(doc['archivoOrigen'] != null && doc['archivoOrigen']!.isNotEmpty && doc['archivoOrigen'] != '-' ? _fileCell(context, doc['archivoOrigen'], 'Archivo de Origen') : const Text('-', overflow: TextOverflow.ellipsis, maxLines: 2))); // ARCHIVO DE ORIGEN
                            cells.add(DataCell(doc['archivoOriginal'] != null && doc['archivoOriginal']!.isNotEmpty && doc['archivoOriginal'] != '-' ? _fileCell(context, doc['archivoOriginal'], 'Archivo Original') : const Text('-', overflow: TextOverflow.ellipsis, maxLines: 2))); // ARCHIVO ORIGINAL
                            cells.add(DataCell(doc['archivoAcuse'] != null && doc['archivoAcuse']!.isNotEmpty && doc['archivoAcuse'] != '-' ? _fileCell(context, doc['archivoAcuse'], 'Archivo Acuse') : const Text('-', overflow: TextOverflow.ellipsis, maxLines: 2))); // ARCHIVO ACUSE
                            cells.add(DataCell(Tooltip(message: doc['nomenclatura'] ?? '-', child: Text(doc['nomenclatura'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // NOMENCLATURA (again)
                            cells.add(DataCell(Tooltip(message: doc['fechaElaboracion'] ?? '-', child: Text(doc['fechaElaboracion'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // FECHA DE ELABORACIÓN
                            cells.add(DataCell(Tooltip(message: doc['dirigidoA'] ?? '-', child: Text(doc['dirigidoA'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // DIRIGIDO A
                            cells.add(DataCell(Tooltip(message: doc['asunto'] ?? '-', child: Text(doc['asunto'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // ASUNTO
                            cells.add(DataCell(Tooltip(message: doc['areaSolicitante'] ?? '-', child: Text(doc['areaSolicitante'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // ÁREA SOLICITANTE
                            cells.add(DataCell(Tooltip(message: doc['quienSolicito'] ?? '-', child: Text(doc['quienSolicito'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // ¿QUIÉN LO SOLICITÓ?
                            cells.add(DataCell(Tooltip(message: doc['observaciones'] ?? '-', child: Text(doc['observaciones'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // OBSERVACIONES
                            // Guarantee 12 cells
                            while (cells.length < 12) {
                              cells.add(const DataCell(Text('-', overflow: TextOverflow.ellipsis, maxLines: 2)));
                            }
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>((states) => i % 2 == 0 ? Colors.white : Colors.grey[100]),
                              cells: cells,
                            );
                          } else {
                            // Crear una lista de DataCells para documentos recibidos con exactamente 12 celdas
                            List<DataCell> cells = [];
                            
                            // Llenar con las celdas existentes
                            cells.add(DataCell(Tooltip(message: doc['nomenclatura'] ?? '-', child: Text(doc['nomenclatura'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // 1. NOMENCLATURA
                            cells.add(DataCell(Center(child: Text(doc['fechaRecepcion'] ?? '-', textAlign: TextAlign.center)))); // 2. FECHA RECEPCIÓN
                            cells.add(DataCell(Tooltip(message: doc['remitente'] ?? '-', child: Text(doc['remitente'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // 3. REMITENTE
                            cells.add(DataCell(Tooltip(message: doc['cargo'] ?? '-', child: Text(doc['cargo'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // 4. CARGO
                            cells.add(DataCell(Tooltip(message: doc['asunto'] ?? '-', child: Text(doc['asunto'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // 5. ASUNTO
                            cells.add(DataCell(Tooltip(message: doc['area'] ?? '-', child: Text(doc['area'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // 6. ÁREA
                            // Campo de copias, si hay datos se muestra botón para ver/descargar PDF
                            cells.add(DataCell(doc['copiasUrl'] != null && doc['copiasUrl']!.isNotEmpty && doc['copiasUrl'] != '-' ? 
                              _fileCell(context, doc['copiasUrl'], 'Copias') : 
                              Tooltip(message: doc['copias'] ?? '-', child: Text(doc['copias'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // 7. COPIAS
                            // Respuesta puede ser booleano o texto según estructura de los datos
                            cells.add(DataCell(doc['respuesta'] == 'true' || doc['respuesta'] == 'false' ? 
                              Center(child: _booleanCell(doc['respuesta'], trueText: 'RESPONDIDO', falseText: 'PENDIENTE')) : 
                              Tooltip(message: doc['respuesta'] ?? '-', child: Text(doc['respuesta'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2)))); // 8. RESPUESTA
                            
                            // 9. Ver PDF Original (usando _fileCell para consistencia)
                            cells.add(DataCell(_fileCell(context, doc['pdfUrl'], 'Archivo Original')));
                            
                            // 10. Ver papeleta (usando _fileCell para consistencia)
                            cells.add(DataCell(_fileCell(context, doc['papeletaUrl'], 'Papeleta')));
                            
                            // 11. Necesita acuse (campo booleano)
                            cells.add(DataCell(Center(child: _booleanCell(doc['necesitaAcuse'], trueText: 'REQUERIDO', falseText: 'NO REQUERIDO'))));
                            
                            // 12. Campo para observaciones o comentarios adicionales
                            cells.add(DataCell(Tooltip(message: doc['observaciones'] ?? '-', child: Text(doc['observaciones'] ?? '-', overflow: TextOverflow.ellipsis, maxLines: 2))));
                            
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>((states) => i % 2 == 0 ? Colors.white : Colors.grey[100]),
                              cells: cells,
                            );
                          }
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper for mobile card fields
  Widget? _docField(String label, String? value) {
    if (value == null || value.isEmpty || value == '-') return null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Flexible(child: Text(value, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  // Helper para campos booleanos (acuse, necesitaAcuse, etc)
  Widget _booleanCell(String? value, {Color? trueColor, Color? falseColor, String? trueText, String? falseText}) {
    // Detección mejorada de valores booleanos con más casos posibles
    final bool boolValue = value != null && 
        (value.toLowerCase() == 'true' || 
         value.toLowerCase() == 'si' || 
         value == '1' || 
         value.toLowerCase() == 'yes' ||
         value.toLowerCase() == 'recibido' ||
         value.toLowerCase() == 'completado' ||
         value.toLowerCase() == 'requerido' ||
         value.toLowerCase() == 'activo');
         
    // Colores por defecto más atractivos
    final displayColor = boolValue 
        ? (trueColor ?? Colors.green[700]!) 
        : (falseColor ?? Colors.orange[700]!);
        
    final bgColor = boolValue
        ? (trueColor?.withOpacity(0.12) ?? Colors.green[50])
        : (falseColor?.withOpacity(0.12) ?? Colors.orange[50]);
        
    final displayText = boolValue 
        ? (trueText ?? 'SI')
        : (falseText ?? 'NO');
    
    // Iconos mejorados según el contexto
    IconData getContextIcon() {
      if (boolValue) {
        if (trueText?.toLowerCase().contains('recibido') ?? false) return Icons.mark_email_read_outlined;
        if (trueText?.toLowerCase().contains('requerido') ?? false) return Icons.assignment_turned_in_outlined;
        if (trueText?.toLowerCase().contains('activo') ?? false) return Icons.check_circle_outline;
        if (trueText?.toLowerCase().contains('respondido') ?? false) return Icons.reply_all_outlined;
        return Icons.check_circle_outline;
      } else {
        if (falseText?.toLowerCase().contains('pendiente') ?? false) return Icons.pending_outlined;
        if (falseText?.toLowerCase().contains('no requerido') ?? false) return Icons.not_interested_outlined;
        if (falseText?.toLowerCase().contains('inactivo') ?? false) return Icons.cancel_outlined;
        return Icons.pending_outlined;
      }
    }
    
    final icon = getContextIcon();
        
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: displayColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: displayColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 14,
            color: displayColor,
          ),
          const SizedBox(width: 5),
          Text(
            displayText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: displayColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileCell(BuildContext context, String? fileUrl, String tooltip) {
    if (fileUrl == null || fileUrl.isEmpty || fileUrl == '-') {
      return const Text('-', overflow: TextOverflow.ellipsis, maxLines: 2);
    }
    
    // Colores personalizados según el tipo de documento
    Color iconColor;
    Color bgColor;
    IconData fileIcon = Icons.picture_as_pdf;
    
    if (tooltip.toLowerCase().contains('acuse')) {
      iconColor = Colors.green[700]!;
      bgColor = Colors.green[50]!;
      fileIcon = Icons.verified_outlined;
    } else if (tooltip.toLowerCase().contains('original')) {
      iconColor = Colors.blue[700]!;
      bgColor = Colors.blue[50]!;
      fileIcon = Icons.description_outlined;
    } else if (tooltip.toLowerCase().contains('papeleta')) {
      iconColor = Colors.amber[800]!;
      bgColor = Colors.amber[50]!;
      fileIcon = Icons.article_outlined;
    } else if (tooltip.toLowerCase().contains('origen')) {
      iconColor = Colors.purple[700]!;
      bgColor = Colors.purple[50]!;
      fileIcon = Icons.source_outlined;
    } else if (tooltip.toLowerCase().contains('copia')) {
      iconColor = Colors.teal[700]!;
      bgColor = Colors.teal[50]!;
      fileIcon = Icons.copy_all_outlined;
    } else {
      iconColor = Colors.red[700]!;
      bgColor = Colors.red[50]!;
    }
    
    // Podemos usar esta información en el futuro para gestionar rutas locales
    // bool isLocalPath = !fileUrl.startsWith('http');
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: iconColor.withOpacity(0.3)),
        color: bgColor.withOpacity(0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono para ver PDF
          Tooltip(
            message: 'Ver $tooltip',
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfViewerPage(
                      pdfPathOrUrl: fileUrl,
                      title: tooltip,
                    ),
                  ),
                );
              },
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(fileIcon, color: iconColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Ver',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Separador vertical
          Container(
            height: 28,
            width: 1,
            color: iconColor.withOpacity(0.2),
          ),
          
          // Icono para descargar PDF
          Tooltip(
            message: 'Descargar $tooltip',
            child: InkWell(
              onTap: () async {
                // Implementación real de descarga usando url_launcher
                try {
                  final uri = Uri.parse(fileUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    
                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Descargando $tooltip...'),
                        backgroundColor: Colors.green[700],
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No se pudo abrir el enlace de descarga.')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al intentar descargar el archivo.')),
                  );
                }
              },
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(7)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Icon(Icons.download, color: Colors.grey[700], size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
