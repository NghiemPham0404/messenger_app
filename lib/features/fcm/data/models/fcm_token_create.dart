import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/fcm/domain/entities/fcm_token_create.dart';

part 'fcm_token_create.g.dart';

@JsonSerializable()
class FcmTokenCreateModel extends FcmTokenCreate {
  @override
  @JsonKey(name: "user_id")
  final int userId;

  @override
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  FcmTokenCreateModel({
    required super.token,
    required this.userId,
    required this.updatedAt,
  }) : super(userId: userId, updatedAt: updatedAt);

  factory FcmTokenCreateModel.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$FcmTokenCreateModelToJson(this);
}
