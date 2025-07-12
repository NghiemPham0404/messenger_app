import 'package:json_annotation/json_annotation.dart';

part 'upload_file_model.g.dart';

@JsonSerializable()
class FileUploaded {
  @JsonKey(name: "file_url")
  String fileUrl;

  @JsonKey(name: "original_filename")
  String? originalName;

  @JsonKey(name: "display_name")
  String? displayFileName;

  String? format;
  int? size;

  FileUploaded({
    required this.fileUrl,
    this.originalName,
    this.displayFileName,
    this.format,
    this.size,
  });

  factory FileUploaded.fromJson(Map<String, dynamic> json) =>
      _$FileUploadedFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadedToJson(this);
}

@JsonSerializable()
class ImageUploaded {
  @JsonKey(name: "image_url")
  String? imageUrl;

  String? originalUrl;

  @JsonKey(name: "original_filename")
  String? originalName;

  @JsonKey(name: "display_name")
  String? displayFileName;

  ImageUploaded({
    this.imageUrl,
    this.displayFileName,
    this.originalUrl,
    this.originalName,
  });

  factory ImageUploaded.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadedFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUploadedToJson(this);
}
