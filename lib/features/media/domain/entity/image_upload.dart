class ImageUploaded {
  String imageUrl;

  String? originalFileName;

  String displayFileName;

  ImageUploaded({
    required this.imageUrl,
    required this.displayFileName,
    this.originalFileName,
  });
}
