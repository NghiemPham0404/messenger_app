import 'package:pulse_chat/features/auth/domain/entities/refresh_token.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_model.g.dart';

@JsonSerializable()
class RefreshTokenModel extends RefreshToken {
  @override
  @JsonKey(name: "refresh_token")
  final String refreshToken;

  RefreshTokenModel({required this.refreshToken})
    : super(refreshToken: refreshToken);

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenModelToJson(this);
}
