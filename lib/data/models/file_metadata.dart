import 'package:json_annotation/json_annotation.dart';

part 'file_metadata.g.dart';

@JsonSerializable()
class FileMetadata {
  String url;
  String name;
  String format;
  int size;

  FileMetadata({
    required this.url,
    required this.name,
    required this.format,
    required this.size,
  });

  factory FileMetadata.fromJson(Map<String, dynamic> json) =>
      _$FileMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataToJson(this);
}
