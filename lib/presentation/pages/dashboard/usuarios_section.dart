import 'package:flutter/material.dart';

class UsuariosSection extends StatelessWidget {
  const UsuariosSection({Key? key}) : super(key: key);
  
  // Helper para campos booleanos (estado: activo/inactivo)
  Widget _booleanCell(String value, {Color? trueColor, Color? falseColor, String? trueText, String? falseText}) {
    // Detección de valores booleanos
    final bool boolValue = value.toLowerCase() == 'true' || 
                           value.toLowerCase() == 'activo';
    
    // Colores según estado
    final displayColor = boolValue 
        ? (trueColor ?? Colors.green[700]!) 
        : (falseColor ?? Colors.red[700]!);
    
    final bgColor = boolValue
        ? (trueColor?.withOpacity(0.12) ?? Colors.green[50])
        : (falseColor?.withOpacity(0.12) ?? Colors.red[50]);
    
    final displayText = boolValue 
        ? (trueText ?? 'ACTIVO')
        : (falseText ?? 'INACTIVO');
    
    final icon = boolValue
        ? Icons.check_circle_outline
        : Icons.cancel_outlined;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: displayColor.withOpacity(0.3)),
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
            ),
          ),
        ],
      ),
    );
  }

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
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('admin@ucips.gob.mx')),
                        const DataCell(Text('Administrador')),
                        const DataCell(Text('Dirección General')),
                        DataCell(Center(child: _booleanCell('true', trueText: 'ACTIVO', falseText: 'INACTIVO'))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('usuario1@ucips.gob.mx')),
                        const DataCell(Text('Usuario Común')),
                        const DataCell(Text('Compras')),
                        DataCell(Center(child: _booleanCell('true', trueText: 'ACTIVO', falseText: 'INACTIVO'))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('auditor@ucips.gob.mx')),
                        const DataCell(Text('Auditor')),
                        const DataCell(Text('Auditoría')),
                        DataCell(Center(child: _booleanCell('false', trueText: 'ACTIVO', falseText: 'INACTIVO'))),
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
