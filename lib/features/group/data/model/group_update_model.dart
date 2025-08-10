import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/group/domain/entities/group_update.dart';

part 'group_update_model.g.dart';

@JsonSerializable()
class GroupUpdateModel extends GroupUpdate {
  @override
  @JsonKey(name: "is_public")
  bool? isPublic;

  @override
  @JsonKey(name: "is_member_mute")
  bool? isMemberMute;

  GroupUpdateModel({
    super.subject,
    super.avatar,
    this.isPublic,
    this.isMemberMute,
  });

  factory GroupUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$GroupUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUpdateModelToJson(this);
}
