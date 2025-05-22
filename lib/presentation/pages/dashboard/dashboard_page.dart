import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:aucips/application/blocs/auth/auth_bloc.dart';
import 'package:aucips/application/blocs/auth/auth_state.dart';
import '../../../application/blocs/auth/auth_event.dart';
import 'reusable_widget.dart';
import 'dashboard_section.dart';
import 'registro_section.dart';
import 'turnado_section.dart';
import 'acuse_section.dart';
import 'usuarios_section.dart';
import 'auditoria_section.dart';
import 'consulta_section.dart';

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
  DateTime? lastBackPressedTime;

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

  // Lista oficial de tipos de documento (código y nombre)
  final List<Map<String, String>> tiposDocumento = [
    {'codigo': 'MEM', 'nombre': 'Memorándum'},
    {'codigo': 'OF', 'nombre': 'Oficio'},
    {'codigo': 'CIR', 'nombre': 'Circular'},
    {'codigo': 'TI', 'nombre': 'Tarjeta Informativa'},
    {'codigo': 'OC', 'nombre': 'Oficio de Comisión'},
    {'codigo': 'PER', 'nombre': 'Documento Personal'},
    {'codigo': 'REC', 'nombre': 'Documento de la Rectora'},
    // {'codigo': 'PAP', 'nombre': 'Papeleta'},
    {'codigo': 'CC', 'nombre': 'Copia de Conocimiento'},
  ];

  String tipoDocumento = 'MEM';
  String asunto = '';
  String area = '';
  String solicitante = '';
  bool acuse = false;
  String nomenclatura = '';
  DateTime? fechaSeleccionada;
  String fechaTexto = '';
  String dirigidoA = '';
  String observaciones = '';
  String enRespuestaA = '';
  String remitente = '';
  String titularDe = '';
  String plazoAtencion = '';
  DateTime? fechaPlazo; // Fecha de plazo de atención
  bool necesitaAcuse = false; // Indica si el documento necesita acuse
  String correosAcuse =
      ''; // Correos electrónicos para acuse separados por comas

  // Estado para búsqueda y filtros
  String busqueda = '';
  String? filtroTipo;
  String? filtroArea;
  String? filtroEstatus;

  // Variables para filtros y búsqueda en consulta
  String filtroTipoDoc = 'Todos';
  String filtroAreaDoc = 'Todos';
  String filtroEstatusDoc = 'Todos';
  String busquedaDoc = '';

  // Estado para archivos PDF de origen y original
  String? archivoOrigenNombre;
  String? archivoOriginalNombre;

  @override
  void initState() {
    super.initState();
    _generarNomenclatura();
  }

  void _generarNomenclatura() {
    final now = DateTime.now();
    final anio = now.year;
    final correlativo = (documentosRegistrados + 1).toString().padLeft(4, '0');
    final areaAbrev = 'ADM'; // Simulado, puedes cambiar según área
    final tipo = tipoDocumento;
    setState(() {
      nomenclatura = 'UCIPS-$areaAbrev-$tipo-$anio-$correlativo';
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('es', ''),
    );
    if (picked != null) {
      setState(() {
        fechaSeleccionada = picked;
        fechaTexto =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _seleccionarFechaPlazo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaPlazo ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('es', ''),
    );
    if (picked != null) {
      setState(() {
        fechaPlazo = picked;
        plazoAtencion =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  // Cambia _simularSubirArchivo para aceptar tipo de archivo
  void _subirArchivo({required bool esOrigen}) async {
    print('Botón presionado: esOrigen = $esOrigen'); // Depuración
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (esOrigen) {
          archivoOrigenNombre = result.files.first.name;
        } else {
          archivoOriginalNombre = result.files.first.name;
        }
      });
    }
  }

  // Validación de correos electrónicos separados por comas
  bool _emailsValidos(String correos) {
    if (correos.isEmpty) {
      return true; // Si está vacío no hay problema
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    final emails = correos
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    for (final email in emails) {
      if (!emailRegExp.hasMatch(email)) {
        return false; // Email inválido
      }
    }

    return true; // Todos los emails válidos
  }

  // Función optimizada para evitar problemas de estado y rendering
  void _registrarDocumento() {
    // Prevenir múltiples llamadas mientras se procesa
    if (registroExitoso) return;

    // Validar formulario básico
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
      return;
    }

    // Validación adicional para correos electrónicos
    if (necesitaAcuse && !_emailsValidos(correosAcuse)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Los correos electrónicos ingresados tienen un formato inválido',
          ),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
      return;
    }

    // Validar archivo
    if (archivoOrigenNombre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor adjunta el archivo de origen (PDF)'),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
      return;
    }
    if (archivoOriginalNombre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor adjunta el archivo original (PDF)'),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
      return;
    }

    // Crear copias locales de los valores actuales
    final String tipoDoc = tipoDocumento == 'Entrada' ? 'MEM' : 'OF';
    final String currentAsunto = asunto;
    final String currentArea = area;

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => WillPopScope(
            onWillPop: () async => false,
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Registrando documento...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    // Usar un Future para desacoplar la actualización de estado
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      try {
        // Actualizar datos
        documentosRegistrados++;
        // Crear documento con todos los campos relevantes
        Map<String, String> nuevoDoc = {
          'tipo': tipoDoc,
          'asunto': currentAsunto,
          'area': currentArea,
          'estatus': 'Pendiente',
        };

        // Si es un documento de entrada, añadir campos específicos
        if (tipoDocumento == 'Entrada') {
          nuevoDoc['plazoAtencion'] = plazoAtencion;
          nuevoDoc['necesitaAcuse'] = necesitaAcuse.toString();
          if (necesitaAcuse) {
            nuevoDoc['correosAcuse'] = correosAcuse;
          }
        }

        documentos.add(nuevoDoc);

        // Cerrar diálogo de carga
        Navigator.of(context).pop();

        // Mostrar mensaje de éxito (primero actualizar esto)
        setState(() {
          registroExitoso = true;
        });

        // Retardo para permitir que la UI se actualice correctamente
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;

          // Navegar a consulta (esto es opcional, puedes comentarlo si causa problemas)
          setState(() {
            section = UCIPSSection.consulta;
          });

          // Limpiar formulario con un retardo adicional
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!mounted) return;

            setState(() {
              archivoNombre = null;
              archivoOrigenNombre = null;
              archivoOriginalNombre = null;
              asunto = '';
              area = '';
              solicitante = '';
              acuse = false;
            });

            // Finalmente, ocultar el mensaje de éxito
            Future.delayed(const Duration(seconds: 1), () {
              if (!mounted) return;
              setState(() {
                registroExitoso = false;
              });
            });
          });
        });
      } catch (e) {
        // Cerrar diálogo si hay error
        Navigator.of(context).pop();

        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  Widget _buildDashboard() {
    return DashboardSection(
      documentosRegistrados: documentosRegistrados,
      turnadosPendientes: turnadosPendientes,
      conAcuse: conAcuse,
      onQuickLinkTap: (UCIPSSection quickSection) {
        setState(() {
          section = quickSection;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const userName = 'Lic. Juan Pérez';
    const userRole = 'Administrador';
    const userArea = 'Dirección General';
    return WillPopScope(
      onWillPop: () async {
        // Si no estamos en el dashboard principal, regresamos a él en lugar de salir
        if (section != UCIPSSection.dashboard) {
          setState(() {
            section = UCIPSSection.dashboard;
          });
          return false;
        }

        // Doble presión para salir
        final now = DateTime.now();
        if (lastBackPressedTime == null ||
            now.difference(lastBackPressedTime!) > const Duration(seconds: 2)) {
          lastBackPressedTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Presiona atrás de nuevo para salir'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
          title: const Text(
            'Administración de Documentos UCIPS',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1A73E8),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.account_circle, color: Color(0xFF1A73E8)),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              userRole,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            userArea,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF1A73E8)),
                child: Row(
                  children: [
                    Image.asset('assets/icons/UCIPS-02.png', height: 40),
                    const SizedBox(width: 12),
                    const Text(
                      'UCIPS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
              // Quitamos Turnado y Acuse Digital del Drawer
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
                  context.read<AuthBloc>().stream.firstWhere((state) => state.status == AuthStatus.unauthenticated).then((_) {
                    context.go('/login');
                  });
                },
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFFF8F9FA),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - 32,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Builder(
                              builder: (context) {
                                switch (section) {
                                  case UCIPSSection.dashboard:
                                    return _buildDashboard();
                                  case UCIPSSection.registro:
                                    return RegistroSection(
                                      registroExitoso: registroExitoso,
                                      archivoNombre: archivoNombre,
                                      archivoOrigenNombre: archivoOrigenNombre,
                                      archivoOriginalNombre:
                                          archivoOriginalNombre,
                                      tipoDocumento: tipoDocumento,
                                      tiposDocumento: tiposDocumento,
                                      asunto: asunto,
                                      area: area,
                                      solicitante: solicitante,
                                      acuse: acuse,
                                      nomenclatura: nomenclatura,
                                      fechaTexto: fechaTexto,
                                      dirigidoA: dirigidoA,
                                      observaciones: observaciones,
                                      enRespuestaA: enRespuestaA,
                                      remitente: remitente,
                                      titularDe: titularDe,
                                      plazoAtencion: plazoAtencion,
                                      necesitaAcuse: necesitaAcuse,
                                      correosAcuse: correosAcuse,
                                      formKey: _formKey,
                                      onTipoDocumentoChanged: (v) {
                                        setState(() {
                                          tipoDocumento = v ?? 'MEM';
                                          _generarNomenclatura();
                                          // Limpiar campos específicos
                                          asunto = '';
                                          area = '';
                                          solicitante = '';
                                          dirigidoA = '';
                                          observaciones = '';
                                          enRespuestaA = '';
                                          remitente = '';
                                          titularDe = '';
                                          plazoAtencion = '';
                                          fechaSeleccionada = null;
                                          fechaTexto = '';
                                          fechaPlazo = null;
                                          necesitaAcuse = false;
                                          correosAcuse = '';
                                        });
                                      },
                                      onAsuntoChanged:
                                          (v) => setState(() => asunto = v),
                                      onAreaChanged:
                                          (v) => setState(() => area = v),
                                      onSolicitanteChanged:
                                          (v) =>
                                              setState(() => solicitante = v),
                                      onAcuseChanged:
                                          (v) => setState(() => acuse = v),
                                      onSubirArchivo:
                                          () {}, // No-op for emission, required for reception
                                      onSubirArchivoOrigen:
                                          () => _subirArchivo(esOrigen: true),
                                      onSubirArchivoOriginal:
                                          () => _subirArchivo(esOrigen: false),
                                      onRegistrar: _registrarDocumento,
                                      onFechaTap:
                                          () => _seleccionarFecha(context),
                                      onPlazoDeTap:
                                          () => _seleccionarFechaPlazo(context),
                                      onDirigidoAChanged:
                                          (v) => setState(() => dirigidoA = v),
                                      onObservacionesChanged:
                                          (v) =>
                                              setState(() => observaciones = v),
                                      onEnRespuestaAChanged:
                                          (v) =>
                                              setState(() => enRespuestaA = v),
                                      onRemitenteChanged:
                                          (v) => setState(() => remitente = v),
                                      onTitularDeChanged:
                                          (v) => setState(() => titularDe = v),
                                      onPlazoAtencionChanged:
                                          (v) =>
                                              setState(() => plazoAtencion = v),
                                      onNecesitaAcuseChanged:
                                          (v) => setState(
                                            () => necesitaAcuse = v ?? false,
                                          ),
                                      onCorreosAcuseChanged:
                                          (v) =>
                                              setState(() => correosAcuse = v),
                                    );
                                  case UCIPSSection.consulta:
                                    return SizedBox(
                                      height: constraints.maxHeight - 32,
                                      child: ConsultaSection(
                                        documentos: documentos,
                                        filtroTipoDoc: filtroTipoDoc,
                                        filtroAreaDoc: filtroAreaDoc,
                                        filtroEstatusDoc: filtroEstatusDoc,
                                        busquedaDoc: busquedaDoc,
                                        onBusquedaChanged:
                                            (v) =>
                                                setState(() => busquedaDoc = v),
                                        onFiltroTipoChanged:
                                            (v) => setState(
                                              () =>
                                                  filtroTipoDoc = v ?? 'Todos',
                                            ),
                                        onFiltroAreaChanged:
                                            (v) => setState(
                                              () =>
                                                  filtroAreaDoc = v ?? 'Todos',
                                            ),
                                        onFiltroEstatusChanged:
                                            (v) => setState(
                                              () =>
                                                  filtroEstatusDoc =
                                                      v ?? 'Todos',
                                            ),
                                        onTurnar:
                                            () => setState(
                                              () =>
                                                  section =
                                                      UCIPSSection.turnado,
                                            ),
                                        onAcuse:
                                            () => setState(
                                              () =>
                                                  section = UCIPSSection.acuse,
                                            ),
                                      ),
                                    );
                                  case UCIPSSection.turnado:
                                    return TurnadoSection(
                                      turnadoA: turnadoA,
                                      onTurnadoAChanged:
                                          (v) => setState(() => turnadoA = v),
                                      onTurnar: () {
                                        if (turnadoA != null) {
                                          setState(() {
                                            turnadosPendientes++;
                                            section = UCIPSSection.consulta;
                                          });
                                        }
                                      },
                                      turnarEnabled: turnadoA != null,
                                    );
                                  case UCIPSSection.acuse:
                                    return AcuseSection(
                                      acuseHecho: acuseHecho,
                                      onAcusarRecibido:
                                          () =>
                                              setState(() => acuseHecho = true),
                                    );
                                  case UCIPSSection.usuarios:
                                    return SizedBox(
                                      height: constraints.maxHeight - 32,
                                      child: UsuariosSection(),
                                    );
                                  case UCIPSSection.auditoria:
                                    return SizedBox(
                                      height: constraints.maxHeight - 32,
                                      child: AuditoriaSection(),
                                    );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CopiableUserTile extends StatelessWidget {
  final String user;
  final String role;
  const _CopiableUserTile({required this.user, required this.role});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('$user ($role)', style: const TextStyle(fontSize: 13)),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          tooltip: 'Copiar usuario',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: user));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Usuario copiado: $user'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CopiablePasswordTile extends StatelessWidget {
  final String password;
  const _CopiablePasswordTile({required this.password});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Contraseña:', style: TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            password,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          tooltip: 'Copiar contraseña',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: password));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contraseña copiada'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }
}
