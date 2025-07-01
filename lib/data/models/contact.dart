import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  int id;

  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "contact_user_id")
  int contactUserId;
  int status;

  @JsonKey(name: "other_user")
  OtherUser otherUser;

  Contact({
    required this.id,
    required this.userId,
    required this.contactUserId,
    required this.status,
    required this.otherUser,
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

@JsonSerializable()
class OtherUser {
  int id;
  String name;
  String? avatar;

  OtherUser({required this.id, required this.name, this.avatar});

  factory OtherUser.fromJson(Map<String, dynamic> json) =>
      _$OtherUserFromJson(json);

  Map<String, dynamic> toJson() => _$OtherUserToJson(this);
}

@JsonSerializable()
class ContactCreate {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "contact_user_id")
  int contactUserId;

  int status;

  ContactCreate({
    required this.status,
    required this.userId,
    required this.contactUserId,
  });

  factory ContactCreate.fromJson(Map<String, dynamic> json) =>
      _$ContactCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ContactCreateToJson(this);
}
