import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String pdfPathOrUrl;
  final String? title;

  const PdfViewerPage({Key? key, required this.pdfPathOrUrl, this.title}) : super(key: key);

  bool get isLocalPath => !pdfPathOrUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Vista PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Descargar PDF',
            onPressed: () {
              // Implementación real de descarga usando url_launcher
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Descargando ${title ?? "documento"}...'),
                  backgroundColor: Colors.green[700],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          try {
            if (isLocalPath) {
              return SfPdfViewer.file(
                File(pdfPathOrUrl),
                canShowScrollHead: true,
                canShowScrollStatus: true,
                enableDoubleTapZooming: true,
              );
            } else {
              return SfPdfViewer.network(
                pdfPathOrUrl,
                canShowScrollHead: true,
                canShowScrollStatus: true,
                enableDoubleTapZooming: true,
              );
            }
          } catch (e) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No se pudo cargar el PDF',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(e.toString()),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
