import 'package:flutter/material.dart';

class ReusableWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  const ReusableWidget({
    Key? key,
    required this.text,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, color: Colors.blue[900], size: 32),
            if (icon != null) const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
