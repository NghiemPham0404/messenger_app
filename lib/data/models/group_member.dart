import 'package:json_annotation/json_annotation.dart';

part 'group_member.g.dart';

class GroupMemberSelection {
  int id;
  String? avatar;

  GroupMemberSelection({required this.id, this.avatar});
}

@JsonSerializable()
class GroupMember {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "group_id")
  int groupId;

  int? id;

  @JsonKey(name: "is_host")
  bool isHost;

  @JsonKey(name: "is_sub_host")
  bool isSubHost;
  int status;
  GroupMemberInfo? member;

  GroupMember({
    required this.userId,
    required this.groupId,
    this.id,
    required this.isHost,
    required this.isSubHost,
    required this.status,
    this.member,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberToJson(this);
}

@JsonSerializable()
class GroupMemberInfo {
  int? id;
  String? name;
  String? avatar;

  GroupMemberInfo({this.id, this.name, this.avatar});

  factory GroupMemberInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberInfoToJson(this);
}

@JsonSerializable()
class GroupMemberCreate {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "group_id")
  int groupId;

  @JsonKey(name: "is_host")
  bool isHost;

  int status;

  GroupMemberCreate({
    required this.userId,
    required this.groupId,
    required this.isHost,
    required this.status,
  });

  factory GroupMemberCreate.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberCreateFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberCreateToJson(this);
}

@JsonSerializable()
class GroupMemberUpdate {
  @JsonKey(name: "is_host")
  bool isHost;

  @JsonKey(name: "is_sub_host")
  bool isSubHost;

  int status;

  GroupMemberUpdate({
    required this.isHost,
    required this.isSubHost,
    required this.status,
  });

  factory GroupMemberUpdate.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberUpdateToJson(this);
}

@JsonSerializable()
class GroupMemberCheck {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "is_host")
  bool isHost;

  @JsonKey(name: "is_sub_host")
  bool isSubHost;

  int status;

  GroupMemberCheck({
    required this.userId,
    required this.isHost,
    required this.isSubHost,
    required this.status,
  });

  factory GroupMemberCheck.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberCheckFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberCheckToJson(this);
}
