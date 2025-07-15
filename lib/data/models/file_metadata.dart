import 'package:json_annotation/json_annotation.dart';

part 'file_metadata.g.dart';

@JsonSerializable()
class FileMetadata {
  String url;
  String name;
  String format;
  int size;

  String? localUrl;
  bool isDownloading = false;
  double progress = 0.0;

  FileMetadata({
    required this.url,
    required this.name,
    required this.format,
    required this.size,

    this.localUrl,
    this.isDownloading = false,
    this.progress = 0.0,
  });

  factory FileMetadata.fromJson(Map<String, dynamic> json) =>
      _$FileMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataToJson(this);
}
