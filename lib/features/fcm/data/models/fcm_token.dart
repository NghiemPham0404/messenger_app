import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/fcm/domain/entities/fcm_token.dart';

part 'fcm_token.g.dart';

@JsonSerializable()
class FcmTokenModel extends FcmToken {
  @override
  @JsonKey(name: "updated_at")
  DateTime updatedAt;

  @override
  @JsonKey(name: "user_id")
  int userId;

  FcmTokenModel({
    required super.id,
    required super.token,
    required this.updatedAt,
    required this.userId,
  }) : super(updatedAt: updatedAt, userId: userId);

  factory FcmTokenModel.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$FcmTokenModelToJson(this);
}
