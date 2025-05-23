import 'package:flutter/material.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define available options for dropdowns
        final tipoOptions = ['Todos', 'Tipo1', 'Tipo2'];
        final areaOptions = ['Todos', 'Área1', 'Área2'];
        final estatusOptions = ['Todos', 'Pendiente', 'Completado', 'En Proceso'];
        
        // Ensure values match the options
        final tipoValue = tipoOptions.contains(filtroTipoDoc) ? filtroTipoDoc : 'Todos';
        final areaValue = areaOptions.contains(filtroAreaDoc) ? filtroAreaDoc : 'Todos';
        final estatusValue = estatusOptions.contains(filtroEstatusDoc) ? filtroEstatusDoc : 'Todos';

        final isMobile = constraints.maxWidth < 600;

        // Layout adaptativo para todos los tamaños de pantalla
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters section - responsive layout for both mobile and desktop
            if (isMobile) ...[
              // Mobile filters in an expandable section
              ExpansionTile(
                title: Text('Filtros', style: TextStyle(fontWeight: FontWeight.bold)),
                initiallyExpanded: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: TextEditingController(text: busquedaDoc),
                      decoration: const InputDecoration(
                        labelText: 'Buscar',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: onBusquedaChanged,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      value: tipoValue,
                      isExpanded: true, // Importante para evitar desbordamientos
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Documento',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      items: tipoOptions.map((tipo) => 
                        DropdownMenuItem(value: tipo, child: Text(tipo, overflow: TextOverflow.ellipsis)) // Added overflow
                      ).toList(),
                      onChanged: onFiltroTipoChanged,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      value: areaValue,
                      isExpanded: true, // Importante para evitar desbordamientos
                      decoration: const InputDecoration(
                        labelText: 'Área',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      items: areaOptions.map((area) => 
                        DropdownMenuItem(value: area, child: Text(area, overflow: TextOverflow.ellipsis)) // Added overflow
                      ).toList(),
                      onChanged: onFiltroAreaChanged,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      value: estatusValue,
                      isExpanded: true, // Importante para evitar desbordamientos
                      decoration: const InputDecoration(
                        labelText: 'Estatus',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      items: estatusOptions.map((estatus) => 
                        DropdownMenuItem(value: estatus, child: Text(estatus, overflow: TextOverflow.ellipsis))
                      ).toList(),
                      onChanged: onFiltroEstatusChanged,
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Desktop filters in a row
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: TextEditingController(text: busquedaDoc),
                        decoration: const InputDecoration(
                          labelText: 'Buscar',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: onBusquedaChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: tipoValue,
                        isExpanded: true, // Importante para evitar desbordamientos
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Documento',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        ),
                        items: tipoOptions.map((tipo) => 
                          DropdownMenuItem(value: tipo, child: Text(tipo, overflow: TextOverflow.ellipsis)) // Added overflow
                        ).toList(),
                        onChanged: onFiltroTipoChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: areaValue,
                        isExpanded: true, // Importante para evitar desbordamientos
                        decoration: const InputDecoration(
                          labelText: 'Área',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        ),
                        items: areaOptions.map((area) => 
                          DropdownMenuItem(value: area, child: Text(area, overflow: TextOverflow.ellipsis)) // Added overflow
                        ).toList(),
                        onChanged: onFiltroAreaChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: estatusValue,
                        isExpanded: true, // Importante para evitar desbordamientos
                        decoration: const InputDecoration(
                          labelText: 'Estatus',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        ),
                        items: estatusOptions.map((estatus) => 
                          DropdownMenuItem(value: estatus, child: Text(estatus, overflow: TextOverflow.ellipsis))
                        ).toList(),
                        onChanged: onFiltroEstatusChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Tabla/Lista adaptativa
            Expanded(
              child: documentos.isEmpty 
                ? const Center(child: Text('No hay documentos para mostrar.'))
                : isMobile 
                  ? _buildMobileTable(tipoFiltro, mostrarTurnar, mostrarAcuse)
                  : _buildDesktopTable(tipoFiltro, constraints),
            ),
          ],
        );
      },
    );
  }

  // Tabla adaptada para móvil con formato de lista
  Widget _buildMobileTable(String tipoFiltro, bool mostrarTurnar, bool mostrarAcuse) {
    // Construir columnas según el tipo de filtro
    List<String> columnTitles;
    List<String> dataKeys;
    
    if (tipoFiltro == 'Salida') {
      columnTitles = ['Nomenclatura', 'Dirigido a', 'Asunto', 'Área Solicitante', 'Estado Acuse'];
      dataKeys = ['nomenclatura', 'dirigidoA', 'asunto', 'areaSolicitante', 'estado_acuse'];
    } else {
      columnTitles = ['Nomenclatura', 'Remitente', 'Asunto', 'Área', 'Estado Acuse'];
      dataKeys = ['nomenclatura', 'remitente', 'asunto', 'area', 'estado_acuse'];
    }
    
    return ListView.builder(
      itemCount: documentos.length,
      itemBuilder: (context, index) {
        final doc = documentos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Replaced Table with Column of Rows for better responsiveness
                    for (int i = 0; i < columnTitles.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0), // Spacing between rows
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120, // Consistent with _buildMobileDetailField
                              child: Text(
                                '${columnTitles[i]}:', // Added colon
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                doc[dataKeys[i]] ?? '-',
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis, // Added this
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const Text(
                        'Detalles adicionales',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (tipoFiltro == 'Salida') ...[
                        _buildMobileDetailField('Fecha de Elaboración', doc['fechaElaboracion']),
                        _buildMobileDetailField('¿Quién lo solicitó?', doc['quienSolicito']),
                        _buildMobileDetailField('Observaciones', doc['observaciones']),
                      ] else ...[
                        _buildMobileDetailField('Fecha de Recepción', doc['fechaRecepcion']),
                        _buildMobileDetailField('Cargo', doc['cargo']),
                        _buildMobileDetailField('Requiere Acuse', doc['requiereAcuse'] == 'true' ? 'Sí' : 'No'),
                        _buildMobileDetailField('Observaciones', doc['observaciones']),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Tabla tradicional para escritorio
  Widget _buildDesktopTable(String tipoFiltro, BoxConstraints constraints) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: constraints.maxWidth),
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith<Color?>((states) => Colors.blue[100]),
          dataRowColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.blue[50];
            }
            return null;
          }),
          columnSpacing: 8,
          dataRowHeight: 44,
          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
          dataTextStyle: const TextStyle(fontSize: 12),
          columns: tipoFiltro == 'Salida'
              ? [
                  const DataColumn(label: Center(child: Text('NOMENCLATURA'))),
                  const DataColumn(label: Center(child: Text('ACUSE'))),
                  const DataColumn(label: Center(child: Text('ARCHIVO DE\nORIGEN'))),
                  const DataColumn(label: Center(child: Text('ARCHIVO\nORIGINAL'))),
                  const DataColumn(label: Center(child: Text('ARCHIVO\nACUSE'))),
                  const DataColumn(label: Center(child: Text('FECHA DE\nELABORACIÓN'))),
                  const DataColumn(label: Center(child: Text('DIRIGIDO A'))),
                  const DataColumn(label: Center(child: Text('ASUNTO'))),
                  const DataColumn(label: Center(child: Text('ÁREA\nSOLICITANTE'))),
                  const DataColumn(label: Center(child: Text('¿QUIÉN LO\nSOLICITÓ?'))),
                  const DataColumn(label: Center(child: Text('OBSERVACIONES'))),
                ]
              : [
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
          rows: documentos.asMap().entries.map((entry) {
            final index = entry.key;
            final doc = entry.value;
            
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue[50];
                }
                return index % 2 == 0 ? Colors.white : Colors.grey[50];
              }),
              cells: tipoFiltro == 'Salida' 
                ? [
                    DataCell(Text(doc['nomenclatura'] ?? '-')),
                    DataCell(Text(doc['acuse'] ?? '-')),
                    DataCell(Text(doc['archivoOrigen'] ?? '-')),
                    DataCell(Text(doc['archivoOriginal'] ?? '-')),
                    DataCell(Text(doc['archivoAcuse'] ?? '-')),
                    DataCell(Text(doc['fechaElaboracion'] ?? '-')),
                    DataCell(Text(doc['dirigidoA'] ?? '-')),
                    DataCell(Text(doc['asunto'] ?? '-')),
                    DataCell(Text(doc['areaSolicitante'] ?? '-')),
                    DataCell(Text(doc['quienSolicito'] ?? '-')),
                    DataCell(Text(doc['observaciones'] ?? '-')),
                  ]
                : [
                    DataCell(Text(doc['nomenclatura'] ?? '-')),
                    DataCell(Text(doc['fechaRecepcion'] ?? '-')),
                    DataCell(Text(doc['remitente'] ?? '-')),
                    DataCell(Text(doc['cargo'] ?? '-')),
                    DataCell(Text(doc['asunto'] ?? '-')),
                    DataCell(Text(doc['area'] ?? '-')),
                    DataCell(Text(doc['copias'] ?? '-')),
                    DataCell(Text(doc['respuesta'] ?? '-')),
                    DataCell(Text(doc['archivoOriginal'] ?? '-')),
                    DataCell(Text(doc['papeleta'] ?? '-')),
                    DataCell(Text(doc['requiereAcuse'] ?? '-')),
                    DataCell(Text(doc['observaciones'] ?? '-')),
                  ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Helper method for mobile detail fields
  Widget _buildMobileDetailField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis, // Added this
            ),
          ),
        ],
      ),
    );
  }
}
