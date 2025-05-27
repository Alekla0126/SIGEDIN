import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/create_document_type.dart' as create_doc_type;
import '../../domain/usecases/delete_document_type.dart' as delete_doc_type;
import '../../domain/usecases/get_document_type.dart' as get_doc_type;
import '../../domain/usecases/get_document_types.dart' as get_doc_types;
import '../../domain/usecases/update_document_type.dart' as update_doc_type;
import 'document_type_event.dart';
import 'document_type_state.dart';

@injectable
class DocumentTypeBloc extends Bloc<DocumentTypeEvent, DocumentTypeState> {
  final get_doc_types.GetDocumentTypes getDocumentTypes;
  final get_doc_type.GetDocumentType getDocumentType;
  final create_doc_type.CreateDocumentType createDocumentType;
  final update_doc_type.UpdateDocumentType updateDocumentType;
  final delete_doc_type.DeleteDocumentType deleteDocumentType;

  DocumentTypeBloc({
    required this.getDocumentTypes,
    required this.getDocumentType,
    required this.createDocumentType,
    required this.updateDocumentType,
    required this.deleteDocumentType,
  }) : super(const DocumentTypeState()) {
    on<LoadDocumentTypes>(_onLoadDocumentTypes);
    on<LoadDocumentType>(_onLoadDocumentType);
    on<CreateDocumentType>(_onCreateDocumentType);
    on<UpdateDocumentType>(_onUpdateDocumentType);
    on<DeleteDocumentType>(_onDeleteDocumentType);
  }

  FutureOr<void> _onLoadDocumentTypes(
    LoadDocumentTypes event,
    Emitter<DocumentTypeState> emit,
  ) async {
    emit(state.copyWith(status: DocumentTypeStatus.loading));

    final result = await getDocumentTypes();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DocumentTypeStatus.failure,
          error: failure.toString(),
        ),
      ),
      (documentTypes) => emit(
        state.copyWith(
          status: DocumentTypeStatus.success,
          documentTypes: documentTypes,
        ),
      ),
    );
  }

  Future<void> _onLoadDocumentType(
    LoadDocumentType event,
    Emitter<DocumentTypeState> emit,
  ) async {
    emit(state.copyWith(status: DocumentTypeStatus.loading));

    final result = await getDocumentType(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: DocumentTypeStatus.failure,
        error: failure.message,
      )),
      (documentType) => emit(state.copyWith(
        status: DocumentTypeStatus.success,
        currentDocumentType: documentType,
      )),
    );
  }

  FutureOr<void> _onCreateDocumentType(
    CreateDocumentType event,
    Emitter<DocumentTypeState> emit,
  ) async {
    emit(state.copyWith(status: DocumentTypeStatus.loading));

    final result = await createDocumentType(
      name: event.name,
      description: event.description,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DocumentTypeStatus.failure,
          error: failure.toString(),
        ),
      ),
      (documentType) => emit(
        state.copyWith(
          status: DocumentTypeStatus.success,
          documentTypes: [...state.documentTypes, documentType],
        ),
      ),
    );
  }

  FutureOr<void> _onUpdateDocumentType(
    UpdateDocumentType event,
    Emitter<DocumentTypeState> emit,
  ) async {
    emit(state.copyWith(status: DocumentTypeStatus.loading));

    final result = await updateDocumentType(
      id: event.id,
      name: event.name,
      description: event.description,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: DocumentTypeStatus.failure,
        error: failure.toString(),
      )),
      (documentType) => emit(state.copyWith(
        status: DocumentTypeStatus.success,
        documentTypes: state.documentTypes
            .map((dt) => dt.id == documentType.id ? documentType : dt)
            .toList(),
        currentDocumentType: documentType,
      )),
    );
  }

  FutureOr<void> _onDeleteDocumentType(
    DeleteDocumentType event,
    Emitter<DocumentTypeState> emit,
  ) async {
    emit(state.copyWith(status: DocumentTypeStatus.loading));

    final result = await deleteDocumentType(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: DocumentTypeStatus.failure,
        error: failure.toString(),
      )),
      (_) => emit(state.copyWith(
        status: DocumentTypeStatus.success,
        documentTypes:
            state.documentTypes.where((dt) => dt.id != event.id).toList(),
        currentDocumentType: state.currentDocumentType?.id == event.id
            ? null
            : state.currentDocumentType,
      )),
    );
  }
}
