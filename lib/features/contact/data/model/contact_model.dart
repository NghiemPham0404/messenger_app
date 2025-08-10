import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';

part 'contact_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactModel extends Contact {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "contact_user_id")
  int contactUserId;

  @JsonKey(name: "other_user")
  final OtherUserModel otherUser;

  ContactModel({
    required super.id,
    required this.userId,
    required this.contactUserId,
    required super.status,
    required this.otherUser,
  }) : super(
         userId: userId,
         contactUserId: contactUserId,
         otherUser: otherUser,
       );

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OtherUserModel extends OtherUser {
  OtherUserModel({required super.id, required super.name, super.avatar});

  factory OtherUserModel.fromJson(Map<String, dynamic> json) =>
      _$OtherUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtherUserModelToJson(this);
}
