library document_reception_bloc;

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:aucips/features/document_reception/domain/entities/document_reception.dart';
import 'package:aucips/features/document_reception/domain/repositories/document_reception_repository.dart';
import 'package:aucips/features/document_reception/domain/usecases/create_document_reception.dart';
import 'package:aucips/features/document_reception/domain/usecases/get_document_reception.dart';
import 'package:aucips/features/document_reception/domain/usecases/download_document_file.dart';
import 'document_reception_event.dart';

class DocumentReceptionBloc extends Bloc<DocumentReceptionEvent, DocumentReceptionState> {
  final CreateDocumentReception createDocumentReception;
  final GetDocumentReception getDocumentReception;
  final DownloadDocumentFile downloadDocumentFile;
  final DocumentReceptionRepository repository;

  DocumentReceptionBloc({
    required this.createDocumentReception,
    required this.getDocumentReception,
    required this.downloadDocumentFile,
    required this.repository,
  }) : super(DocumentReceptionInitial()) {
    on<CreateDocumentReceptionEvent>(_onCreateDocumentReception);
    on<GetDocumentReceptionEvent>(_onGetDocumentReception);
    on<DownloadDocumentFileEvent>(_onDownloadDocumentFile);
    on<ResetDocumentReceptionStatus>(_onResetStatus);
  }

  Future<void> _onCreateDocumentReception(
    CreateDocumentReceptionEvent event,
    Emitter<DocumentReceptionState> emit,
  ) async {
    try {
      emit(DocumentReceptionLoading());
      
      final result = await createDocumentReception(
        tipo: event.tipo,
        remitente: event.remitente,
        asunto: event.asunto,
        requiereAcuse: event.requiereAcuse,
        fechaRecepcion: event.fechaRecepcion,
        titularDe: event.titularDe,
        observaciones: event.observaciones,
        plazoAtencion: event.plazoAtencion,
        filePath: event.filePath,
      );
      
      result.fold(
        (failure) => emit(DocumentReceptionFailure(failure.toString())),
        (document) => emit(DocumentReceptionSuccess(document)),
      );
    } catch (e) {
      emit(DocumentReceptionFailure('Error al crear el documento: $e'));
    }
  }

  Future<void> _onDownloadDocumentFile(
    DownloadDocumentFileEvent event,
    Emitter<DocumentReceptionState> emit,
  ) async {
    try {
      emit(DocumentReceptionLoading());
      final result = await downloadDocumentFile(event.id);
      
      result.fold(
        (failure) => emit(DocumentReceptionFailure(failure.toString())),
        (filePath) => emit(DocumentReceptionFileDownloaded(filePath)),
      );
    } catch (e) {
      emit(DocumentReceptionFailure('Error al descargar el archivo: $e'));
    }
  }

  Future<void> _onGetDocumentReception(
    GetDocumentReceptionEvent event,
    Emitter<DocumentReceptionState> emit,
  ) async {
    try {
      emit(DocumentReceptionLoading());
      final result = await getDocumentReception(event.id);
      
      result.fold(
        (failure) => emit(DocumentReceptionFailure(failure.toString())),
        (document) => emit(DocumentReceptionSuccess(document)),
      );
    } catch (e) {
      emit(DocumentReceptionFailure('Error al obtener el documento: $e'));
    }
  }

  void _onResetStatus(
    ResetDocumentReceptionStatus event,
    Emitter<DocumentReceptionState> emit,
  ) {
    emit(DocumentReceptionInitial());
  }
}

// States
abstract class DocumentReceptionState extends Equatable {
  const DocumentReceptionState();

  @override
  List<Object> get props => [];
}

class DocumentReceptionInitial extends DocumentReceptionState {}

class DocumentReceptionLoading extends DocumentReceptionState {}

class DocumentReceptionSuccess extends DocumentReceptionState {
  final DocumentReception document;

  const DocumentReceptionSuccess(this.document);

  @override
  List<Object> get props => [document];
}

class DocumentReceptionFileDownloaded extends DocumentReceptionState {
  final String filePath;

  const DocumentReceptionFileDownloaded(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class DocumentReceptionFailure extends DocumentReceptionState {
  final String message;

  const DocumentReceptionFailure(this.message);

  @override
  List<Object> get props => [message];
}
