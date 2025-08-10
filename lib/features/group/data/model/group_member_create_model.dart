import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_create.dart';

part 'group_member_create_model.g.dart';

@JsonSerializable()
class GroupMemberCreateModel extends GroupMemberCreate {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "group_id")
  int groupId;

  @JsonKey(name: "is_host")
  bool isHost;

  GroupMemberCreateModel({
    required this.userId,
    required this.groupId,
    required this.isHost,
    required super.status,
  }) : super(groupId: groupId, userId: userId, isHost: isHost);

  factory GroupMemberCreateModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberCreateModelToJson(this);
}
