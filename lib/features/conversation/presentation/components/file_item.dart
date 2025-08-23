import 'package:pulse_chat/features/conversation/presentation/components/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../../media/domain/entity/file_metadata.dart';

class FileItem extends StatefulWidget {
  final FileMetadata fileMetadata;
  final VoidCallback onDownloadFile;

  const FileItem(this.fileMetadata, this.onDownloadFile, {super.key});

  @override
  State<StatefulWidget> createState() {
    return FileItemState();
  }
}

class FileItemState extends State<FileItem> {
  late final FileMetadata file;
  late final VoidCallback onTap;

  @override
  void initState() {
    super.initState();

    file = widget.fileMetadata;
    onTap = widget.onDownloadFile;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => file.localUrl == null ? onTap() : _openFile(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 10,
            children: [
              getFileIconAsset(file.format, fileName: file.name),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Text(file.format, maxLines: 1),
                        Text(formatBytes(file.size), maxLines: 1),
                      ],
                    ),
                    offlineStatus(),
                  ],
                ),
              ),
              if (file.isDownloading) downloadStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget offlineStatus() {
    return file.localUrl == null
        ? Row(
          spacing: 5,
          children: [
            Icon(Icons.info_outline, size: 16),
            Text("download for offline", maxLines: 1),
          ],
        )
        : Row(
          spacing: 5,
          children: [
            Icon(Icons.check_rounded, size: 16, color: Colors.green),
            Text("ready for use", maxLines: 1),
          ],
        );
  }

  Widget downloadStatus() {
    return SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        value: file.progress,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  String formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      double mb = bytes / (1024 * 1024);
      return "${mb.toStringAsFixed(2)} MB";
    } else if (bytes >= 1024) {
      double kb = bytes / 1024;
      return "${kb.toStringAsFixed(2)} KB";
    } else {
      return "$bytes B";
    }
  }

  void _openFile(BuildContext context) async {
    final result = await OpenFilex.open(file.localUrl!);

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open file: ${result.message}')),
      );
    }
  }
}
