import 'package:flutter/material.dart';
import 'reusable_widget.dart';

class AcuseSection extends StatelessWidget {
  final bool acuseHecho;
  final VoidCallback onAcusarRecibido;

  const AcuseSection({
    Key? key,
    required this.acuseHecho,
    required this.onAcusarRecibido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Acuse Digital', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (!acuseHecho)
            SizedBox(
              width: 200, // Fixed width to prevent unconstrained layout
              child: ElevatedButton(
                onPressed: onAcusarRecibido,
                child: const Text('Acusar Recibido'),
              ),
            ),
          if (acuseHecho)
            const ReusableWidget(
              text: '¡Acuse realizado exitosamente!',
              icon: Icons.check_circle_outline,
              color: Color(0xFFC8E6C9),
            ),
        ],
      ),
    );
  }
}
