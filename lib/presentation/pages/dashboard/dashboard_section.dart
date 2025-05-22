import 'package:flutter/material.dart';
import 'reusable_widget.dart';
import 'dashboard_page.dart';

class DashboardSection extends StatelessWidget {
  final int documentosRegistrados;
  final int turnadosPendientes;
  final int conAcuse;
  final void Function(UCIPSSection section)? onQuickLinkTap;

  const DashboardSection({
    Key? key,
    required this.documentosRegistrados,
    required this.turnadosPendientes,
    required this.conAcuse,
    this.onQuickLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 700;
        final cardWidth = isSmall ? double.infinity : 320.0;

        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo y título
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/UCIPS-02.png', height: 48),
                      const SizedBox(width: 16),
                      const Text(
                        'Sistema de Control Documental',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Tarjetas de estadísticas con diseño mejorado
                Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Título de la sección
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Tablero de Control',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                      ),

                      // Tarjetas en grid/wrap centrado
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: ReusableWidget(
                              text:
                                  'Documentos registrados: $documentosRegistrados',
                              icon: Icons.folder_open,
                              color: const Color(0xFFE1F5FE),
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: ReusableWidget(
                              text: 'Turnados pendientes: $turnadosPendientes',
                              icon: Icons.send,
                              color: const Color(0xFFE8F5E9),
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: ReusableWidget(
                              text: 'Con acuse: $conAcuse',
                              icon: Icons.verified,
                              color: const Color(0xFFFFFDE7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Mensaje de bienvenida mejorado
                Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: const ReusableWidget(
                    text:
                        'Bienvenido al sistema UCIPS. Selecciona una sección en el menú.',
                    icon: Icons.info_outline,
                    color: Color(0xFFEDE7F6),
                  ),
                ),

                const SizedBox(height: 40),

                // Enlaces rápidos
                Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Accesos rápidos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _buildQuickLink(
                                context,
                                'Registrar documento',
                                Icons.post_add,
                                Colors.blue,
                                UCIPSSection.registro,
                              ),
                              _buildQuickLink(
                                context,
                                'Consultar documentos',
                                Icons.search,
                                Colors.green,
                                UCIPSSection.consulta,
                              ),
                              _buildQuickLink(
                                context,
                                'Documentos recientes',
                                Icons.history,
                                Colors.amber,
                                UCIPSSection.consulta, // Or a new section if exists
                              ),
                              _buildQuickLink(
                                context,
                                'Ayuda',
                                Icons.help_outline,
                                Colors.purple,
                                null, // No section, could show help dialog
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper para crear enlaces rápidos
  Widget _buildQuickLink(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    UCIPSSection? section,
  ) {
    return InkWell(
      onTap: () {
        if (onQuickLinkTap != null && section != null) {
          onQuickLinkTap!(section);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Acceso rápido a: $label')),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
