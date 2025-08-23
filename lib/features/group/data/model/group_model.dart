import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';

part 'group_model.g.dart';

@JsonSerializable()
class GroupModel extends Group {
  @override
  @JsonKey(name: "is_public")
  bool isPublic;

  @override
  @JsonKey(name: "is_member_mute")
  bool isMemberMute;

  @override
  @JsonKey(name: "member_count")
  int? membersCount;

  GroupModel({
    required super.id,
    required super.subject,
    required super.avatar,
    required this.isPublic,
    required this.isMemberMute,
    this.membersCount,
  }) : super(
         isPublic: isPublic,
         isMemberMute: isMemberMute,
         membersCount: membersCount,
       );

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}
