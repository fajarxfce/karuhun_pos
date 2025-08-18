import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../presentation/screen/document_directory_screen.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc() : super(DocumentInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    // Dummy data, nested folders/files
    final List<DocumentItem> items = _dummyData(event.parentId);
    emit(DocumentLoaded(items));
  }

  List<DocumentItem> _dummyData(String? parentId) {
    // Simulate a large, nested structure
    if (parentId == null) {
      return List.generate(10, (i) =>
        DocumentItem(id: 'f$i', name: 'Folder $i', type: 'folder')
      ) + List.generate(10, (i) =>
        DocumentItem(id: 'file$i', name: 'File $i.pdf', type: 'file', size: 1000 + i * 100, mimeType: 'application/pdf')
      );
    } else if (parentId.startsWith('f')) {
      int idx = int.parse(parentId.substring(1));
      if (idx < 5) {
        return [
          DocumentItem(id: 'f${parentId}_a', name: 'Subfolder A', type: 'folder', parentId: parentId),
          DocumentItem(id: 'f${parentId}_b', name: 'Subfolder B', type: 'folder', parentId: parentId),
          DocumentItem(id: 'file${parentId}_1', name: 'File $parentId-1.txt', type: 'file', parentId: parentId, size: 2000, mimeType: 'text/plain'),
        ];
      } else {
        return List.generate(5, (i) =>
          DocumentItem(id: 'file${parentId}_$i', name: 'File $parentId-$i.docx', type: 'file', parentId: parentId, size: 1500 + i * 100, mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        );
      }
    } else {
      return [];
    }
  }
}
