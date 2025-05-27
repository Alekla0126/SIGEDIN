import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/document_type_bloc.dart';
import '../bloc/document_type_event.dart';
import '../widgets/document_type_list.dart';

class DocumentTypeListPage extends StatelessWidget {
  const DocumentTypeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Types'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create document type page
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = context.read<DocumentTypeBloc>();
          bloc.add(LoadDocumentTypes());
          return bloc;
        },
        child: DocumentTypeList(),
      ),
    );
  }
}
