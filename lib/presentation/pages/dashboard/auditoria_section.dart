import 'package:flutter/material.dart';

class AuditoriaSection extends StatelessWidget {
  const AuditoriaSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bitácora de Auditoría', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 500),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Fecha')),
                      DataColumn(label: Text('Usuario')),
                      DataColumn(label: Text('Acción')),
                      DataColumn(label: Text('Área')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('2025-05-21')),
                        DataCell(Text('admin@ucips.gob.mx')),
                        DataCell(Text('Registro de documento')),
                        DataCell(Text('Dirección General')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('2025-05-20')),
                        DataCell(Text('usuario1@ucips.gob.mx')),
                        DataCell(Text('Turnado de documento')),
                        DataCell(Text('Compras')),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
