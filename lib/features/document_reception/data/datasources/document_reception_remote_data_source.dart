import 'dart:io';

import 'package:aucips/core/error/exceptions.dart';
import 'package:aucips/core/network/api_client.dart';
import 'package:aucips/features/document_reception/data/models/document_reception_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

abstract class DocumentReceptionRemoteDataSource {
  Future<DocumentReceptionModel> createDocumentReception({
    required String tipo,
    required String remitente,
    required String asunto,
    required bool requiereAcuse,
    required DateTime fechaRecepcion,
    required String titularDe,
    String? observaciones,
    int? plazoAtencion,
    required String filePath,
  });

  Future<DocumentReceptionModel> getDocumentReception(int id);
  Future<String> downloadDocumentFile(int id);
}

class DocumentReceptionRemoteDataSourceImpl
    implements DocumentReceptionRemoteDataSource {
  final ApiClient apiClient;

  DocumentReceptionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DocumentReceptionModel> createDocumentReception({
    required String tipo,
    required String remitente,
    required String asunto,
    required bool requiereAcuse,
    required DateTime fechaRecepcion,
    required String titularDe,
    String? observaciones,
    int? plazoAtencion,
    required String filePath,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw const FileNotFoundException();
      }

      final response = await apiClient.multipartPost<Map<String, dynamic>>(
        path: '/documentos/documentos/recepcion',
        fields: {
          'tipo': tipo,
          'remitente': remitente,
          'asunto': asunto,
          'requiere_acuse': requiereAcuse.toString(),
          'fecha_recepcion': fechaRecepcion.toIso8601String(),
          'titular_de': titularDe,
          if (observaciones != null) 'observaciones': observaciones,
          if (plazoAtencion != null) 'plazo_atencion': plazoAtencion.toString(),
        },
        files: {
          'documento': filePath,
        },
      );

      return response.fold(
        (failure) => throw ServerException(message: failure.message),
        (json) => DocumentReceptionModel.fromJson(json['data'] ?? json),
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DocumentReceptionModel> getDocumentReception(int id) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/documentos/documentos/recepcion/$id',
    );

    return response.fold(
      (failure) => throw ServerException(message: failure.message),
      (json) => DocumentReceptionModel.fromJson(json['data'] ?? json),
    );
  }

  @override
  Future<String> downloadDocumentFile(int id) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = path.join(tempDir.path, 'document_$id.pdf');
      final file = File(filePath);

      final response = await apiClient.downloadFile(
        '/documentos/documentos/recepcion/archivo/$id',
        file,
      );

      return response.fold(
        (failure) => throw ServerException(message: failure.message),
        (_) => filePath,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
