import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/media/domain/entity/file_upload.dart';

part 'file_uploaded_model.g.dart';

@JsonSerializable()
class FileUploadedModel extends FileUploaded {
  @override
  @JsonKey(name: "file_url")
  String fileUrl;

  @override
  @JsonKey(name: "display_name")
  String displayFileName;

  @override
  @JsonKey(name: "original_filename")
  String? originalName;

  FileUploadedModel({
    required this.fileUrl,
    required this.displayFileName,
    this.originalName,
    super.format,
    super.size,
  }) : super(
         fileUrl: fileUrl,
         displayFileName: displayFileName,
         originalName: originalName,
       );

  factory FileUploadedModel.fromJson(Map<String, dynamic> json) =>
      _$FileUploadedModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadedModelToJson(this);
}
