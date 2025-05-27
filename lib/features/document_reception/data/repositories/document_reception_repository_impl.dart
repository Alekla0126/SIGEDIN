import 'dart:io';

import 'package:aucips/core/error/exceptions.dart';
import 'package:aucips/core/error/failures.dart';
import 'package:aucips/features/document_reception/data/datasources/document_reception_remote_data_source.dart';
import 'package:aucips/features/document_reception/domain/entities/document_reception.dart';
import 'package:aucips/features/document_reception/domain/repositories/document_reception_repository.dart';
import 'package:aucips/features/document_reception/data/models/document_reception_model.dart';
import 'package:dartz/dartz.dart';

// Extension to convert between model and entity
extension DocumentReceptionModelX on DocumentReceptionModel {
  DocumentReception toEntity() {
    return DocumentReception(
      id: this.id,
      tipo: this.tipo,
      remitente: this.remitente,
      asunto: this.asunto,
      requiereAcuse: this.requiereAcuse,
      fechaRecepcion: this.fechaRecepcion,
      titularDe: this.titularDe,
      observaciones: this.observaciones,
      folio: this.folio,
      plazoAtencion: this.plazoAtencion,
      estado: this.estado,
      receptorId: this.receptorId,
      createdAt: this.createdAt,
      urlDocumento: this.urlDocumento,
    );
  }
}

class DocumentReceptionRepositoryImpl implements DocumentReceptionRepository {
  final DocumentReceptionRemoteDataSource remoteDataSource;

  DocumentReceptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DocumentReception>> createDocumentReception({
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
      final documentModel = await remoteDataSource.createDocumentReception(
        tipo: tipo,
        remitente: remitente,
        asunto: asunto,
        requiereAcuse: requiereAcuse,
        fechaRecepcion: fechaRecepcion,
        titularDe: titularDe,
        observaciones: observaciones,
        plazoAtencion: plazoAtencion,
        filePath: filePath,
      );
      return Right(documentModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return Left(ServerFailure(message: 'No Internet connection'));
    } on Exception {
      return Left(ServerFailure(message: 'Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, DocumentReception>> getDocumentReception(int id) async {
    try {
      final documentModel = await remoteDataSource.getDocumentReception(id);
      return Right(documentModel.toEntity());
    } on ServerException {
      return Left(ServerFailure(message: 'Server error'));
    } on SocketException {
      return Left(ServerFailure(message: 'No Internet connection'));
    } on Exception {
      return Left(ServerFailure(message: 'Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadDocumentFile(int id) async {
    try {
      final filePath = await remoteDataSource.downloadDocumentFile(id);
      return Right(filePath);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return Left(ServerFailure(message: 'No Internet connection'));
    } on Exception {
      return Left(ServerFailure(message: 'Failed to download document'));
    }
  }
}
