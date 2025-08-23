class FileUploaded {
  String fileUrl;

  String? originalName;

  String displayFileName;

  String? format;
  int? size;

  FileUploaded({
    required this.fileUrl,
    required this.displayFileName,
    this.originalName,
    this.format,
    this.size,
  });
}
