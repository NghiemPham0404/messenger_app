import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact_create.dart';

part 'contact_create_model.g.dart';

@JsonSerializable()
class ContactCreateModel extends ContactCreate {
  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "contact_user_id")
  int contactUserId;

  ContactCreateModel({
    required this.userId,
    required this.contactUserId,
    required super.status,
  }) : super(userId: userId, contactUserId: contactUserId);

  factory ContactCreateModel.fromJson(Map<String, dynamic> json) =>
      _$ContactCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactCreateModelToJson(this);
}
