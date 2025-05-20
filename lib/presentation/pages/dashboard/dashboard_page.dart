import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/auth/auth_bloc.dart';
import '../../../application/blocs/auth/auth_event.dart';

// Enum para las secciones simuladas
enum UCIPSSection {
  dashboard,
  registro,
  consulta,
  turnado,
  acuse,
  usuarios,
  auditoria,
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  UCIPSSection section = UCIPSSection.dashboard;

  // Simulación de datos
  int documentosRegistrados = 12;
  int turnadosPendientes = 3;
  int conAcuse = 8;
  List<Map<String, String>> documentos = [
    {
      'tipo': 'MEM',
      'asunto': 'Solicitud de material',
      'area': 'Recursos Materiales',
      'estatus': 'Turnado',
    },
    {
      'tipo': 'OF',
      'asunto': 'Oficio de respuesta',
      'area': 'Dirección',
      'estatus': 'Archivado',
    },
    {
      'tipo': 'OC',
      'asunto': 'Orden de compra',
      'area': 'Compras',
      'estatus': 'Pendiente',
    },
  ];
  String? archivoNombre;
  bool registroExitoso = false;
  String? turnadoA;
  bool acuseHecho = false;

  // Formulario de registro
  final _formKey = GlobalKey<FormState>();
  String tipoDocumento = 'Entrada';
  String asunto = '';
  String area = '';
  String solicitante = '';
  bool acuse = false;

  void _simularSubirArchivo() {
    setState(() {
      archivoNombre = 'documento_prueba.pdf';
    });
  }

  void _registrarDocumento() {
    // Validación: solo ejecuta si el form es válido y hay archivo
    if ((_formKey.currentState?.validate() ?? false) && archivoNombre != null) {
      setState(() {
        documentosRegistrados++;
        registroExitoso = true;
        documentos.add({
          'tipo': tipoDocumento == 'Entrada' ? 'MEM' : 'OF',
          'asunto': asunto,
          'area': area,
          'estatus': 'Pendiente',
        });
        archivoNombre = null;
        asunto = '';
        area = '';
        solicitante = '';
        acuse = false;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          registroExitoso = false;
        });
      });
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1A73E8)),
            child: Center(
              child: Text('UCIPS', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: section == UCIPSSection.dashboard,
            onTap: () => setState(() => section = UCIPSSection.dashboard),
          ),
          ListTile(
            leading: const Icon(Icons.add_box_rounded),
            title: const Text('Registrar Documento'),
            selected: section == UCIPSSection.registro,
            onTap: () => setState(() => section = UCIPSSection.registro),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Consulta de Documentos'),
            selected: section == UCIPSSection.consulta,
            onTap: () => setState(() => section = UCIPSSection.consulta),
          ),
          ListTile(
            leading: const Icon(Icons.send),
            title: const Text('Turnado'),
            selected: section == UCIPSSection.turnado,
            onTap: () => setState(() => section = UCIPSSection.turnado),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Acuse Digital'),
            selected: section == UCIPSSection.acuse,
            onTap: () => setState(() => section = UCIPSSection.acuse),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Usuarios'),
            selected: section == UCIPSSection.usuarios,
            onTap: () => setState(() => section = UCIPSSection.usuarios),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Bitácora'),
            selected: section == UCIPSSection.auditoria,
            onTap: () => setState(() => section = UCIPSSection.auditoria),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar sesión'),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _ReusableWidget(
                  text: 'Documentos registrados: $documentosRegistrados',
                  icon: Icons.folder_open,
                  color: const Color(0xFFBBDEFB),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ReusableWidget(
                  text: 'Turnados pendientes: $turnadosPendientes',
                  icon: Icons.send,
                  color: const Color(0xFFC8E6C9),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ReusableWidget(
                  text: 'Con acuse: $conAcuse',
                  icon: Icons.verified,
                  color: const Color(0xFFFFF9C4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const _ReusableWidget(
            text: 'Bienvenido al sistema UCIPS. Selecciona una sección en el menú.',
            icon: Icons.info_outline,
            color: Color(0xFFE3F2FD),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistro() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Registro de Documento', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (registroExitoso)
                const _ReusableWidget(
                  text: '¡Documento registrado exitosamente!',
                  icon: Icons.check_circle_outline,
                  color: Color(0xFFC8E6C9),
                ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: tipoDocumento,
                      decoration: const InputDecoration(labelText: 'Tipo de documento'),
                      items: const [
                        DropdownMenuItem(value: 'Entrada', child: Text('Entrada')),
                        DropdownMenuItem(value: 'Salida', child: Text('Salida')),
                      ],
                      onChanged: (v) => setState(() => tipoDocumento = v ?? 'Entrada'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Asunto'),
                      initialValue: asunto,
                      onChanged: (v) => asunto = v,
                      validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Área'),
                      initialValue: area,
                      onChanged: (v) => area = v,
                      validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Solicitante'),
                      initialValue: solicitante,
                      onChanged: (v) => solicitante = v,
                      validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Subir PDF'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                          onPressed: _simularSubirArchivo,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            archivoNombre ?? 'Ningún archivo seleccionado',
                            style: TextStyle(
                              color: archivoNombre != null ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      value: acuse,
                      onChanged: (v) => setState(() => acuse = v ?? false),
                      title: const Text('¿Requiere acuse digital?'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _registrarDocumento,
                      child: const Text('Registrar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsulta() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Consulta de Documentos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Tipo')),
                DataColumn(label: Text('Asunto')),
                DataColumn(label: Text('Área')),
                DataColumn(label: Text('Estatus')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: documentos.map((doc) {
                return DataRow(cells: [
                  DataCell(Text(doc['tipo'] ?? '')),
                  DataCell(Text(doc['asunto'] ?? '')),
                  DataCell(Text(doc['area'] ?? '')),
                  DataCell(Text(doc['estatus'] ?? '')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'Ver',
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        tooltip: 'Turnar',
                        onPressed: () => setState(() => section = UCIPSSection.turnado),
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
        ],
      ),
    );
  }

  Widget _buildTurnado() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Turnar Documento', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: turnadoA,
            decoration: const InputDecoration(labelText: 'Turnar a'),
            items: const [
              DropdownMenuItem(value: 'Dirección', child: Text('Dirección')),
              DropdownMenuItem(value: 'Rectoría', child: Text('Rectoría')),
              DropdownMenuItem(value: 'Compras', child: Text('Compras')),
            ],
            onChanged: (v) => setState(() => turnadoA = v),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: turnadoA != null
                ? () {
                    setState(() {
                      turnadosPendientes++;
                      section = UCIPSSection.consulta;
                    });
                  }
                : null,
            child: const Text('Turnar'),
          ),
        ],
      ),
    );
  }

  Widget _buildAcuse() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Acuse Digital', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (!acuseHecho)
            ElevatedButton(
              onPressed: () => setState(() => acuseHecho = true),
              child: const Text('Acusar Recibido'),
            ),
          if (acuseHecho)
            const _ReusableWidget(
              text: '¡Acuse realizado exitosamente!',
              icon: Icons.check_circle_outline,
              color: Color(0xFFC8E6C9),
            ),
        ],
      ),
    );
  }

  Widget _buildUsuarios() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gestión de Usuarios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DataTable(
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
        ],
      ),
    );
  }

  Widget _buildAuditoria() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bitácora de Auditoría', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DataTable(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const userName = 'Lic. Juan Pérez';
    const userRole = 'Administrador';
    const userArea = 'Dirección General';
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCIPS – Unidad de Control Institucional de Procesos y Servicios'),
        backgroundColor: const Color(0xFF1A73E8),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle, color: Colors.white),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(userName, style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(userRole, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(userArea, style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 900)
            SizedBox(
              width: 260,
              child: _buildDrawer(),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Builder(
                    builder: (context) {
                      switch (section) {
                        case UCIPSSection.dashboard:
                          return _buildDashboard();
                        case UCIPSSection.registro:
                          return _buildRegistro();
                        case UCIPSSection.consulta:
                          return _buildConsulta();
                        case UCIPSSection.turnado:
                          return _buildTurnado();
                        case UCIPSSection.acuse:
                          return _buildAcuse();
                        case UCIPSSection.usuarios:
                          return _buildUsuarios();
                        case UCIPSSection.auditoria:
                          return _buildAuditoria();
                      }
                    },
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

// Widget reutilizable local para evitar conflictos de importación
class _ReusableWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  const _ReusableWidget({Key? key, required this.text, this.icon, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, color: Colors.blue[900], size: 32),
            if (icon != null) const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
