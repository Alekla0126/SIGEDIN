import 'package:flutter/material.dart';

class TurnadoSection extends StatelessWidget {
  final String? turnadoA;
  final Function(String?) onTurnadoChanged;
  final VoidCallback onTurnar;

  const TurnadoSection({
    Key? key,
    required this.turnadoA,
    required this.onTurnadoChanged,
    required this.onTurnar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Turnado Section Placeholder'),
    );
  }
}