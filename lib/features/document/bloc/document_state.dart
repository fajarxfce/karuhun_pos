part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}
class DocumentLoading extends DocumentState {}
class DocumentLoaded extends DocumentState {
  final List<DocumentItem> items;
  const DocumentLoaded(this.items);

  @override
  List<Object?> get props => [items];
}
class DocumentError extends DocumentState {
  final String message;
  const DocumentError(this.message);

  @override
  List<Object?> get props => [message];
}
