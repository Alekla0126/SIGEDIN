import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

Future<DateTime?> seleccionarFecha(BuildContext context, DateTime? fechaSeleccionada) async {
  return await showDatePicker(
    context: context,
    initialDate: fechaSeleccionada ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    locale: const Locale('es', ''),
  );
}

Future<DateTime?> seleccionarFechaPlazo(BuildContext context, DateTime? fechaPlazo) async {
  return await showDatePicker(
    context: context,
    initialDate: fechaPlazo ?? DateTime.now().add(const Duration(days: 7)),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    locale: const Locale('es', ''),
  );
}

Future<String?> simularSubirArchivo() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    withData: false,
  );
  return result?.files.first.name;
}

bool emailsValidos(String correos) {
  if (correos.isEmpty) {
    return true;
  }

  final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
  final emails = correos.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);

  for (final email in emails) {
    if (!emailRegExp.hasMatch(email)) {
      return false;
    }
  }

  return true;
}
