import 'package:json_annotation/json_annotation.dart';

part 'fcm_token.g.dart';

@JsonSerializable()
class FCMTokenModel {
  int id;
  String token;

  @JsonKey(name: "updated_at")
  DateTime updatedAt;

  @JsonKey(name: "user_id")
  int userId;

  FCMTokenModel({
    required this.id,
    required this.token,
    required this.updatedAt,
    required this.userId,
  });

  factory FCMTokenModel.fromJson(Map<String, dynamic> json) =>
      _$FCMTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$FCMTokenModelToJson(this);
}
