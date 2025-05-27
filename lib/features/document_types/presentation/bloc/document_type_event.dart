import 'package:equatable/equatable.dart';

import '../../domain/entities/document_type.dart';

abstract class DocumentTypeEvent extends Equatable {
  const DocumentTypeEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocumentTypes extends DocumentTypeEvent {}

class LoadDocumentType extends DocumentTypeEvent {
  final String id;

  const LoadDocumentType(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateDocumentType extends DocumentTypeEvent {
  final String name;
  final String? description;

  const CreateDocumentType({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class UpdateDocumentType extends DocumentTypeEvent {
  final String id;
  final String? name;
  final String? description;

  const UpdateDocumentType({
    required this.id,
    this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}

class DeleteDocumentType extends DocumentTypeEvent {
  final String id;

  const DeleteDocumentType(this.id);

  @override
  List<Object?> get props => [id];
}
