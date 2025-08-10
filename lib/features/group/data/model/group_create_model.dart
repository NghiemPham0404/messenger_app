import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/group/domain/entities/group_create.dart';

part 'group_create_model.g.dart';

@JsonSerializable()
class GroupCreateModel extends GroupCreate {
  GroupCreateModel({required super.subject, super.avatar});

  factory GroupCreateModel.fromJson(Map<String, dynamic> json) =>
      _$GroupCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupCreateModelToJson(this);
}
