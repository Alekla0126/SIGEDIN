import 'package:flutter/material.dart';

/// Un widget que maneja el comportamiento del botón "atrás"
/// Permite navegar entre secciones y requiere doble tap para salir
class BackHandlerWidget extends StatefulWidget {
  final Widget child;
  final bool Function() onWillPop;
  
  const BackHandlerWidget({
    Key? key, 
    required this.child,
    required this.onWillPop,
  }) : super(key: key);

  @override
  State<BackHandlerWidget> createState() => _BackHandlerWidgetState();
}

class _BackHandlerWidgetState extends State<BackHandlerWidget> {
  DateTime? _lastBackPressedTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Primero verificamos si hay navegación interna
        if (!widget.onWillPop()) {
          return false;
        }
        
        // Si llegamos aquí, implementamos el doble tap para salir
        final now = DateTime.now();
        if (_lastBackPressedTime == null || 
            now.difference(_lastBackPressedTime!) > const Duration(seconds: 2)) {
          _lastBackPressedTime = now;
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
      child: widget.child,
    );
  }
}
