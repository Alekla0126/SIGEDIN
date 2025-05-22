import 'package:flutter/material.dart';

class AcuseSection extends StatelessWidget {
  final bool acuseHecho;
  final VoidCallback onAcusar;

  const AcuseSection({
    Key? key,
    required this.acuseHecho,
    required this.onAcusar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Acuse Section Placeholder'),
    );
  }
}