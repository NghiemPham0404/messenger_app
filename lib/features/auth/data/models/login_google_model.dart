import 'package:pulse_chat/features/auth/domain/entities/login_google.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_google_model.g.dart';

@JsonSerializable()
class GoogleLoginModel extends GoogleLogin {
  @override
  @JsonKey(name: "provider_id")
  final String providerId;

  GoogleLoginModel({
    required super.email,
    required super.username,
    required super.avatar,
    required this.providerId,
  }) : super(providerId: providerId);

  factory GoogleLoginModel.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleLoginModelToJson(this);
}
