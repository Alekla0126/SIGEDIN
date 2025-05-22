import 'package:flutter/material.dart';

class UsuariosSection extends StatelessWidget {
  const UsuariosSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gestión de Usuarios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                      DataColumn(label: Text('Usuario')),
                      DataColumn(label: Text('Rol')),
                      DataColumn(label: Text('Área')),
                      DataColumn(label: Text('Estado')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('admin@ucips.gob.mx')),
                        DataCell(Text('Administrador')),
                        DataCell(Text('Dirección General')),
                        DataCell(Text('Activo')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('usuario1@ucips.gob.mx')),
                        DataCell(Text('Usuario Común')),
                        DataCell(Text('Compras')),
                        DataCell(Text('Activo')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('auditor@ucips.gob.mx')),
                        DataCell(Text('Auditor')),
                        DataCell(Text('Auditoría')),
                        DataCell(Text('Inactivo')),
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
