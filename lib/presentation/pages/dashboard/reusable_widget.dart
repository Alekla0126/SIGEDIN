import 'package:flutter/material.dart';

class ReusableWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  const ReusableWidget({Key? key, required this.text, this.icon, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extraemos un color base de la tarjeta para usarlo en el ícono
    final Color baseColor = color ?? Colors.blue[50] ?? Colors.blue;
    final Color iconColor = Color.lerp(baseColor, Colors.black, 0.7) ?? Colors.blue[900] ?? Colors.blue;
    
    return Card(
      elevation: 3,
      color: color ?? Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(baseColor, Colors.white, 0.3) ?? baseColor,
              baseColor,
            ],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(right: 20),
                child: Icon(icon, color: iconColor, size: 32),
              ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Color.lerp(baseColor, Colors.black, 0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
