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
              physics: const ClampingScrollPhysics(),
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
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Buscar',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: onBusquedaChanged,
                        controller: TextEditingController(text: busquedaDoc),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: tipoValue,
                        decoration: const InputDecoration(
                          labelText: 'Tipo',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: tipos.map((t) => DropdownMenuItem(value: t['codigo'] as String, child: Text(t['nombre'] as String))).toList(),
                        onChanged: onFiltroTipoChanged,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: areaValue,
                        decoration: const InputDecoration(
                          labelText: 'Área',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: areas.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                        onChanged: onFiltroAreaChanged,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: estatusValue,
                        decoration: const InputDecoration(
                          labelText: 'Estatus',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: estatuses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: onFiltroEstatusChanged,
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
                          ),
                          onChanged: onBusquedaChanged,
                          controller: TextEditingController(text: busquedaDoc),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: tipoValue,
                          decoration: const InputDecoration(
                            labelText: 'Tipo',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: tipos.map((t) => DropdownMenuItem(value: t['codigo'] as String, child: Text(t['nombre'] as String))).toList(),
                          onChanged: onFiltroTipoChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: areaValue,
                          decoration: const InputDecoration(
                            labelText: 'Área',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: areas.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                          onChanged: onFiltroAreaChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: estatusValue,
                          decoration: const InputDecoration(
                            labelText: 'Estatus',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: estatuses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: onFiltroEstatusChanged,
                        ),
                      ),
                    ],
                  ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: isMobile ? 600 : 900),
                    child: DataTable(
                      columns: [
                        const DataColumn(label: Text('Tipo')),
                        if (tipoFiltro == 'Salida') ...[
                          const DataColumn(label: Text('A quién se dirige')),
                          const DataColumn(label: Text('Asunto')),
                          const DataColumn(label: Text('Área solicitante')),
                          const DataColumn(label: Text('Solicitante')),
                        ] else ...[
                          const DataColumn(label: Text('Remitente')),
                          const DataColumn(label: Text('Titular de')),
                          const DataColumn(label: Text('Asunto')),
                          const DataColumn(label: Text('Plazo de atención')),
                          const DataColumn(label: Text('Acuse')),
                        ],
                        const DataColumn(label: Text('Estatus')),
                        const DataColumn(label: Text('Acciones')),
                      ],
                      rows: docsFiltrados.map((doc) {
                        return DataRow(cells: [
                          DataCell(Text(doc['tipo'] ?? '')),
                          if (tipoFiltro == 'Salida') ...[
                            DataCell(Text(doc['dirigidoA'] ?? '-')),
                            DataCell(Text(doc['asunto'] ?? '-')),
                            DataCell(Text(doc['area'] ?? '-')),
                            DataCell(Text(doc['solicitante'] ?? '-')),
                          ] else ...[
                            DataCell(Text(doc['remitente'] ?? '-')),
                            DataCell(Text(doc['titularDe'] ?? '-')),
                            DataCell(Text(doc['asunto'] ?? '-')),
                            DataCell(Text(doc['plazoAtencion'] ?? '-')),
                            DataCell(
                              doc['necesitaAcuse'] == 'true' 
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : const Icon(Icons.circle_outlined, color: Colors.grey)
                            ),
                          ],
                          DataCell(Text(doc['estatus'] ?? '-')),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (mostrarTurnar)
                                IconButton(
                                  icon: const Icon(Icons.send),
                                  tooltip: 'Turnar',
                                  onPressed: onTurnar,
                                ),
                              if (mostrarAcuse)
                                IconButton(
                                  icon: const Icon(Icons.verified),
                                  tooltip: 'Acuse digital',
                                  onPressed: onAcuse,
                                ),
                              IconButton(
                                icon: const Icon(Icons.picture_as_pdf),
                                tooltip: 'Exportar PDF',
                                onPressed: () {},
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
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
}
