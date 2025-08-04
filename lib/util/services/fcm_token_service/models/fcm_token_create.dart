import 'package:json_annotation/json_annotation.dart';

part 'fcm_token_create.g.dart';

@JsonSerializable()
class FcmTokenCreateModel {
  final String token;

  @JsonKey(name: "user_id")
  final String userId;

  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  FcmTokenCreateModel({
    required this.token,
    required this.userId,
    required this.updatedAt,
  });

  factory FcmTokenCreateModel.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$FcmTokenCreateModelToJson(this);
}
