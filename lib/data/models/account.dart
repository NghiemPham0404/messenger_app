import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class SignUpModel {
  final String email;
  final String name;
  final String password;

  SignUpModel({
    required this.email,
    required this.name,
    required this.password,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}

@JsonSerializable()
class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}

@JsonSerializable()
class GoogleLoginModel {
  final String email;
  final String username;
  final String avatar;
  final String provider = "google";

  @JsonKey(name: "provider_id")
  final String providerId;

  GoogleLoginModel({
    required this.email,
    required this.username,
    required this.avatar,
    required this.providerId,
  });

  factory GoogleLoginModel.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleLoginModelToJson(this);
}
