part of 'document_bloc.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentEvent {
  final String? parentId;
  const LoadDocuments({this.parentId});

  @override
  List<Object?> get props => [parentId];
}
