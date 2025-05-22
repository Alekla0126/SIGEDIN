import 'package:flutter/material.dart';

class TurnadoSection extends StatelessWidget {
  final String? turnadoA;
  final ValueChanged<String?> onTurnadoAChanged;
  final VoidCallback onTurnar;
  final bool turnarEnabled;

  const TurnadoSection({
    Key? key,
    required this.turnadoA,
    required this.onTurnadoAChanged,
    required this.onTurnar,
    required this.turnarEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onChanged: onTurnadoAChanged,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200, // Fixed width to prevent unconstrained layout
            child: ElevatedButton(
              onPressed: turnarEnabled ? onTurnar : null,
              child: const Text('Turnar'),
            ),
          ),
        ],
      ),
    );
  }
}
