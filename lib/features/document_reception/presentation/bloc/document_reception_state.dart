import 'package:equatable/equatable.dart';
import 'package:aucips/features/document_reception/domain/entities/document_reception.dart';

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
