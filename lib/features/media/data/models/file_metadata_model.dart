import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';

part 'file_metadata_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FileMetadataModel extends FileMetadata {
  FileMetadataModel({
    required super.url,
    required super.name,
    required super.format,
    required super.size,
  });

  factory FileMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$FileMetadataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataModelToJson(this);
}
