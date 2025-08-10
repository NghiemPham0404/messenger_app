import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_check.dart';

part 'group_member_check_model.g.dart';

@JsonSerializable()
class GroupMemberCheckModel extends GroupMemberCheck {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "is_host")
  bool isHost;

  @JsonKey(name: "is_sub_host")
  bool isSubHost;

  @JsonKey(name: "group_member_id")
  int? groupMemberId;

  GroupMemberCheckModel({
    required super.status,
    required this.userId,
    required this.isHost,
    required this.isSubHost,
    this.groupMemberId,
  }) : super(
         groupMemberId: groupMemberId,
         userId: userId,
         isHost: isHost,
         isSubHost: isSubHost,
       );

  factory GroupMemberCheckModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberCheckModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberCheckModelToJson(this);
}
