import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/user/domain/entities/user_extend.dart';

part 'user_extended_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserExtendedModel extends UserExtended {
  @override
  @JsonKey(name: "relationship")
  final RelationshipModel relationship;

  UserExtendedModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    required this.relationship,
  }) : super(relationship: relationship);

  factory UserExtendedModel.fromJson(Map<String, dynamic> json) =>
      _$UserExtendedModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserExtendedModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RelationshipModel extends Relationship {
  @JsonKey(name: "contact_id")
  @override
  int contactId;

  @JsonKey(name: "contact_status")
  @override
  int contactStatus;

  @JsonKey(name: "is_sent_request")
  @override
  bool isSentRequest;

  RelationshipModel({
    required this.contactId,
    required this.contactStatus,
    required this.isSentRequest,
  }) : super(
         contactId: contactId,
         contactStatus: contactStatus,
         isSentRequest: isSentRequest,
       );

  factory RelationshipModel.fromJson(Map<String, dynamic> json) =>
      _$RelationshipModelFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipModelToJson(this);
}
