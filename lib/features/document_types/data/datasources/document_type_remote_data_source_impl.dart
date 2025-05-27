import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/document_type.dart';
import '../models/document_type_model.dart';
import 'document_type_remote_data_source.dart';

@LazySingleton(as: DocumentTypeRemoteDataSource)
class DocumentTypeRemoteDataSourceImpl implements DocumentTypeRemoteDataSource {
  final ApiClient client;

  DocumentTypeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<DocumentType>> getDocumentTypes() async {
    final response = await client.get<List<dynamic>>(
      '/document-types',
      fromJson: (json) => json as List<dynamic>,
    );

    return response.fold(
      (failure) => throw failure,
      (data) => (data ?? [])
          .map((item) => DocumentTypeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<DocumentType> getDocumentType(String id) async {
    final response = await client.get<Map<String, dynamic>>(
      '/document-types/$id',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return response.fold(
      (failure) => throw failure,
      (data) => DocumentTypeModel.fromJson(data),
    );
  }

  @override
  Future<DocumentType> createDocumentType({
    required String name,
    String? description,
  }) async {
    final response = await client.post<Map<String, dynamic>>(
      '/document-types',
      body: {
        'name': name,
        if (description != null) 'description': description,
      },
    );

    return response.fold(
      (failure) => throw failure,
      (data) => DocumentTypeModel.fromJson(data ?? {}),
    );
  }

  @override
  Future<DocumentType> updateDocumentType({
    required String id,
    String? name,
    String? description,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;

    final response = await client.put<Map<String, dynamic>>(
      '/document-types/$id',
      body: body.isNotEmpty ? body : null,
    );

    return response.fold(
      (failure) => throw failure,
      (data) => DocumentTypeModel.fromJson(data ?? {}),
    );
  }

  @override
  Future<void> deleteDocumentType(String id) async {
    final response = await client.delete<void>(
      '/document-types/$id',
      fromJson: (_) {},
    );

    return response.fold(
      (failure) => throw failure,
      (_) {},
    );
  }
}
