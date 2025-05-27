import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/repositories/document_type_repository.dart';
import '../datasources/document_type_remote_data_source.dart';

@LazySingleton(as: DocumentTypeRepository)
class DocumentTypeRepositoryImpl implements DocumentTypeRepository {
  final DocumentTypeRemoteDataSource remoteDataSource;

  DocumentTypeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DocumentType>>> getDocumentTypes() async {
    try {
      final documentTypes = await remoteDataSource.getDocumentTypes();
      return Right(documentTypes);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DocumentType>> getDocumentType(String id) async {
    try {
      final documentType = await remoteDataSource.getDocumentType(id);
      return Right(documentType);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DocumentType>> createDocumentType({
    required String name,
    String? description,
  }) async {
    try {
      final documentType = await remoteDataSource.createDocumentType(
        name: name,
        description: description,
      );
      return Right(documentType);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DocumentType>> updateDocumentType({
    required String id,
    String? name,
    String? description,
  }) async {
    try {
      final documentType = await remoteDataSource.updateDocumentType(
        id: id,
        name: name,
        description: description,
      );
      return Right(documentType);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocumentType(String id) async {
    try {
      await remoteDataSource.deleteDocumentType(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
