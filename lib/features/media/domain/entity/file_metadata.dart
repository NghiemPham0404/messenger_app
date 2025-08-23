import 'package:json_annotation/json_annotation.dart';

class FileMetadata {
  String url;
  String name;
  String format;
  int size;

  @JsonKey(includeFromJson: false)
  String? localUrl;

  @JsonKey(includeFromJson: false)
  bool isDownloading = false;

  @JsonKey(includeFromJson: false)
  double progress = 0.0;

  FileMetadata({
    required this.url,
    required this.name,
    required this.format,
    required this.size,
    this.localUrl,
  }) : isDownloading = false,
       progress = 0.0;
}
