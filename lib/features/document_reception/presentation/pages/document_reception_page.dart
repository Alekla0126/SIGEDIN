import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:aucips/features/document_reception/presentation/bloc/document_reception_bloc.dart';
import 'package:aucips/features/document_reception/presentation/bloc/document_reception_event.dart';
// DocumentReception entity import removed as it's not used

class DocumentReceptionPage extends StatelessWidget {
  const DocumentReceptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Documento de Recepción'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<DocumentReceptionBloc, DocumentReceptionState>(
          listener: (context, state) {
            if (state is DocumentReceptionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Documento registrado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              // Clear form or navigate back
              Navigator.pop(context, true);
            } else if (state is DocumentReceptionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const DocumentReceptionForm(),
        ),
      ),
    );
  }
}

class DocumentReceptionForm extends StatefulWidget {
  const DocumentReceptionForm({Key? key}) : super(key: key);

  @override
  _DocumentReceptionFormState createState() => _DocumentReceptionFormState();
}

class _DocumentReceptionFormState extends State<DocumentReceptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _tipoController = TextEditingController();
  final _remitenteController = TextEditingController();
  final _asuntoController = TextEditingController();
  final _titularDeController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _plazoAtencionController = TextEditingController();
  
  bool _requiereAcuse = false;
  DateTime? _fechaRecepcion;
  String? _filePath;

  final List<Map<String, String>> _tiposDocumento = [
    {'codigo': 'OFICIO', 'nombre': 'Oficio'},
    {'codigo': 'MEMORANDUM', 'nombre': 'Memorándum'},
    {'codigo': 'CIRCULAR', 'nombre': 'Circular'},
    {'codigo': 'OTRO', 'nombre': 'Otro'},
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fechaRecepcion) {
      setState(() {
        _fechaRecepcion = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _filePath = result.files.single.path!;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al seleccionar el archivo. Asegúrese de que sea un PDF.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _fechaRecepcion != null && _filePath != null) {
      // Ensure all required fields are not empty
      final tipo = _tipoController.text.trim();
      final remitente = _remitenteController.text.trim();
      final asunto = _asuntoController.text.trim();
      final titularDe = _titularDeController.text.trim();
      final observaciones = _observacionesController.text.trim().isNotEmpty 
          ? _observacionesController.text.trim() 
          : null;
      final plazoAtencion = _plazoAtencionController.text.trim().isNotEmpty 
          ? int.tryParse(_plazoAtencionController.text.trim()) 
          : null;
      
      if (tipo.isEmpty || remitente.isEmpty || asunto.isEmpty || titularDe.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor complete todos los campos requeridos'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      context.read<DocumentReceptionBloc>().add(
            CreateDocumentReceptionEvent(
              tipo: tipo,
              remitente: remitente,
              asunto: asunto,
              requiereAcuse: _requiereAcuse,
              fechaRecepcion: _fechaRecepcion!,
              titularDe: titularDe,
              observaciones: observaciones,
              plazoAtencion: plazoAtencion,
              filePath: _filePath!,
            ),
          );
    } else {
      String errorMessage = 'Por favor complete todos los campos requeridos';
      if (_fechaRecepcion == null) {
        errorMessage += ' y seleccione una fecha de recepción';
      }
      if (_filePath == null) {
        errorMessage += ' y seleccione un archivo PDF';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _remitenteController.dispose();
    _asuntoController.dispose();
    _titularDeController.dispose();
    _observacionesController.dispose();
    _plazoAtencionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentReceptionBloc, DocumentReceptionState>(
      builder: (context, state) {
        return Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tipo de documento
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de documento',
                      border: OutlineInputBorder(),
                    ),
                    value: _tipoController.text.isNotEmpty ? _tipoController.text : null,
                    items: _tiposDocumento.map((tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo['codigo'],
                        child: Text(tipo['nombre']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _tipoController.text = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor seleccione un tipo de documento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Remitente
                  TextFormField(
                    controller: _remitenteController,
                    decoration: const InputDecoration(
                      labelText: 'Remitente',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el remitente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Asunto
                  TextFormField(
                    controller: _asuntoController,
                    decoration: const InputDecoration(
                      labelText: 'Asunto',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el asunto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Fecha de recepción
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de recepción',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _fechaRecepcion != null
                            ? DateFormat('dd/MM/yyyy').format(_fechaRecepcion!)
                            : 'Seleccione una fecha',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Titular de
                  TextFormField(
                    controller: _titularDeController,
                    decoration: const InputDecoration(
                      labelText: 'Dirigido a',
                      border: OutlineInputBorder(),
                      hintText: 'Nombre de la persona o área destinataria',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por ingrese el destinatario';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Requiere acuse
                  SwitchListTile(
                    title: const Text('¿Requiere acuse?'),
                    value: _requiereAcuse,
                    onChanged: (value) {
                      setState(() {
                        _requiereAcuse = value;
                      });
                    },
                    secondary: const Icon(Icons.receipt_long),
                  ),
                  
                  // Plazo de atención (días)
                  TextFormField(
                    controller: _plazoAtencionController,
                    decoration: const InputDecoration(
                      labelText: 'Plazo de atención (días)',
                      border: OutlineInputBorder(),
                      hintText: 'Opcional',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  
                  // Observaciones
                  TextFormField(
                    controller: _observacionesController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                      border: OutlineInputBorder(),
                      hintText: 'Opcional',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  
                  // Seleccionar archivo
                  OutlinedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: Text(_filePath != null 
                        ? 'Archivo seleccionado: ${_filePath!.split('/').last}'
                        : 'Seleccionar archivo PDF'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  if (_filePath != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Tamaño: ${_getFileSize(_filePath!)}\nExtensión: PDF',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 32),
                  
                  // Botón de envío
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Registrar Documento',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            if (state is DocumentReceptionLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
  
  String _getFileSize(String path) {
    try {
      final file = File(path);
      if (!file.existsSync()) return 'Archivo no encontrado';
      
      final sizeInBytes = file.lengthSync();
      if (sizeInBytes < 1024) return '$sizeInBytes B';
      
      final sizeInKB = sizeInBytes / 1024;
      if (sizeInKB < 1024) return '${sizeInKB.toStringAsFixed(2)} KB';
      
      final sizeInMB = sizeInKB / 1024;
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } catch (e) {
      return 'Tamaño desconocido';
    }
  }
}
