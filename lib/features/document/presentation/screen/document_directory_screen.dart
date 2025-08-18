import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/document_bloc.dart';

class DocumentItem {
  final String id;
  final String name;
  final String type; // 'file' or 'folder'
  final String? parentId;
  final int? size;
  final String? mimeType;
  final DateTime? createdAt;

  DocumentItem({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.size,
    this.mimeType,
    this.createdAt,
  });

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      parentId: json['parent_id'],
      size: json['size'],
      mimeType: json['mime_type'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }
}

class DocumentDirectoryScreen extends StatelessWidget {
  final String? parentId;
  final String? folderName;
  const DocumentDirectoryScreen({Key? key, this.parentId, this.folderName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentBloc()..add(LoadDocuments(parentId: parentId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(folderName ?? 'Dokumen'),
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
        ),
        body: BlocBuilder<DocumentBloc, DocumentState>(
          builder: (context, state) {
            if (state is DocumentLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DocumentLoaded) {
              final items = state.items;
              if (items.isEmpty) {
                return const Center(child: Text('Folder kosong'));
              }
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Icon(item.type == 'folder' ? Icons.folder : Icons.insert_drive_file),
                    title: Text(item.name),
                    subtitle: item.type == 'file' ? Text('${item.size ?? 0} bytes') : null,
                    onTap: () {
                      if (item.type == 'folder') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DocumentDirectoryScreen(
                              parentId: item.id,
                              folderName: item.name,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Open file: ${item.name}')),
                        );
                      }
                    },
                  );
                },
              );
            }
            if (state is DocumentError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
