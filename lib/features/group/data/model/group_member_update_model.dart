import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_update.dart';

part 'group_member_update_model.g.dart';

@JsonSerializable()
class GroupMemberUpdateModel extends GroupMemberUpdate {
  @JsonKey(name: "is_host")
  bool isHost;

  @JsonKey(name: "is_sub_host")
  bool isSubHost;

  GroupMemberUpdateModel({
    required this.isHost,
    required this.isSubHost,
    required super.status,
  }) : super(isHost: isHost, isSubHost: isSubHost);

  factory GroupMemberUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberUpdateModelToJson(this);
}
