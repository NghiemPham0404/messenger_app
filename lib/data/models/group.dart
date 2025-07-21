import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  int id;
  String subject;
  String? avatar;

  @JsonKey(name: "is_public")
  bool isPublic;

  @JsonKey(name: "is_member_mute")
  bool isMemberMute;

  Group({
    required this.id,
    required this.subject,
    required this.avatar,
    required this.isPublic,
    required this.isMemberMute,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class GroupCreate {
  String subject;
  String? avatar;

  GroupCreate({required this.subject, this.avatar});

  factory GroupCreate.fromJson(Map<String, dynamic> json) =>
      _$GroupCreateFromJson(json);

  Map<String, dynamic> toJson() => _$GroupCreateToJson(this);
}

@JsonSerializable()
class GroupUpdate {
  String? subject;
  String? avatar;

  @JsonKey(name: "is_public")
  bool? isPublic;

  @JsonKey(name: "is_member_mute")
  bool? isMemberMute;

  GroupUpdate({this.subject, this.avatar, this.isPublic, this.isMemberMute});

  factory GroupUpdate.fromJson(Map<String, dynamic> json) =>
      _$GroupUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUpdateToJson(this);
}
