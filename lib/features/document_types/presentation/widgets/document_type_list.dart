import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/document_type.dart';
import '../bloc/document_type_bloc.dart';
import '../bloc/document_type_event.dart';
import '../bloc/document_type_state.dart';

class DocumentTypeList extends StatelessWidget {
  const DocumentTypeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentTypeBloc, DocumentTypeState>(
      builder: (context, state) {
        if (state.status == DocumentTypeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == DocumentTypeStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load document types'),
                const SizedBox(height: 8),
                Text(
                  state.error ?? 'Unknown error',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<DocumentTypeBloc>().add(LoadDocumentTypes());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.documentTypes.isEmpty) {
          return const Center(
            child: Text('No document types found'),
          );
        }

        return ListView.builder(
          itemCount: state.documentTypes.length,
          itemBuilder: (context, index) {
            final documentType = state.documentTypes[index];
            return DocumentTypeListItem(
              documentType: documentType,
              onTap: () {
                // TODO: Navigate to document type details
              },
              onEdit: () {
                // TODO: Show edit dialog
              },
              onDelete: () {
                _showDeleteConfirmation(context, documentType);
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, DocumentType documentType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document Type'),
        content: Text(
            'Are you sure you want to delete "${documentType.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<DocumentTypeBloc>()
                  .add(DeleteDocumentType(documentType.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}

class DocumentTypeListItem extends StatelessWidget {
  final DocumentType documentType;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DocumentTypeListItem({
    super.key,
    required this.documentType,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(documentType.name),
      subtitle: documentType.description != null
          ? Text(documentType.description!)
          : null,
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'edit':
              onEdit();
              break;
            case 'delete':
              onDelete();
              break;
          }
        },
      ),
      onTap: onTap,
    );
  }
}
