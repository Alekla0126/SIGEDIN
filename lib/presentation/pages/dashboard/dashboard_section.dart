import 'package:flutter/material.dart';
import 'reusable_widget.dart';

class DashboardSection extends StatelessWidget {
  final int documentosRegistrados;
  final int turnadosPendientes;
  final int conAcuse;

  const DashboardSection({
    Key? key,
    required this.documentosRegistrados,
    required this.turnadosPendientes,
    required this.conAcuse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 700;
        final screenWidth = MediaQuery.of(context).size.width;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: isSmall ? double.infinity : 320,
                      child: ReusableWidget(
                        text: 'Documentos registrados: $documentosRegistrados',
                        icon: Icons.folder_open,
                        color: const Color(0xFFBBDEFB),
                      ),
                    ),
                    SizedBox(
                      width: isSmall ? double.infinity : 320,
                      child: ReusableWidget(
                        text: 'Turnados pendientes: $turnadosPendientes',
                        icon: Icons.send,
                        color: const Color(0xFFC8E6C9),
                      ),
                    ),
                    SizedBox(
                      width: isSmall ? (screenWidth - 32) : 320,
                      child: ReusableWidget(
                        text: 'Con acuse: $conAcuse',
                        icon: Icons.verified,
                        color: const Color(0xFFFFF9C4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const ReusableWidget(
                text: 'Bienvenido al sistema UCIPS. Selecciona una sección en el menú.',
                icon: Icons.info_outline,
                color: Color(0xFFE3F2FD),
              ),
            ],
          ),
        );
      },
    );
  }
}
