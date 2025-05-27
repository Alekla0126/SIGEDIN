import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/document_type.dart';
import '../bloc/document_type_bloc.dart';
import '../bloc/document_type_event.dart';

class DocumentTypeForm extends StatefulWidget {
  final DocumentType? initialDocumentType;

  const DocumentTypeForm({
    super.key,
    this.initialDocumentType,
  });

  @override
  State<DocumentTypeForm> createState() => _DocumentTypeFormState();
}

class _DocumentTypeFormState extends State<DocumentTypeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialDocumentType?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialDocumentType?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  widget.initialDocumentType == null ? 'Create' : 'Update',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      if (widget.initialDocumentType == null) {
        // Create new document type
        context.read<DocumentTypeBloc>().add(
              CreateDocumentType(
                name: name,
                description: description.isNotEmpty ? description : null,
              ),
            );
      } else {
        // Update existing document type
        context.read<DocumentTypeBloc>().add(
              UpdateDocumentType(
                id: widget.initialDocumentType!.id,
                name: name,
                description: description.isNotEmpty ? description : null,
              ),
            );
      }

      Navigator.of(context).pop();
    }
  }
}
