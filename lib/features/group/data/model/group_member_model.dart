import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';

part 'group_member_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupMemberModel extends GroupMember {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "group_id")
  int groupId;

  @JsonKey(name: "is_host")
  bool isHost;

  @JsonKey(name: "is_sub_host")
  bool isSubHost;

  @JsonKey(name: "member")
  final GroupMemberInfoModel? member;

  GroupMemberModel({
    required this.userId,
    required this.groupId,
    required super.id,
    required this.isHost,
    required this.isSubHost,
    required super.status,
    this.member,
  }) : super(
         userId: userId,
         groupId: groupId,
         isHost: isHost,
         isSubHost: isSubHost,
         member: member,
       );

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GroupMemberInfoModel extends GroupMemberInfo {
  GroupMemberInfoModel({super.id, super.name, super.avatar});

  factory GroupMemberInfoModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberInfoModelToJson(this);
}
