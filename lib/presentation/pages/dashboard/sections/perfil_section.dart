import 'package:flutter/material.dart';

class PerfilSection extends StatelessWidget {
  final bool isDarkTheme;
  final Color primaryColor;
  final Function(bool) onThemeChanged;
  final Function(Color) onColorChanged;

  const PerfilSection({
    Key? key,
    required this.isDarkTheme,
    required this.primaryColor,
    required this.onThemeChanged,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Perfil Section Placeholder'),
    );
  }
}