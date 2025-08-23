import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/media/domain/entity/image_upload.dart';

part 'image_uploaded_model.g.dart';

@JsonSerializable()
class ImageUploadedModel extends ImageUploaded {
  @override
  @JsonKey(name: "image_url")
  String imageUrl;

  @override
  @JsonKey(name: "display_name")
  String displayFileName;

  @override
  @JsonKey(name: "original_filename")
  String? originalFileName;

  ImageUploadedModel({
    required this.imageUrl,
    required this.displayFileName,
    this.originalFileName,
  }) : super(
         imageUrl: imageUrl,
         displayFileName: displayFileName,
         originalFileName: originalFileName,
       );

  factory ImageUploadedModel.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadedModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUploadedModelToJson(this);
}
