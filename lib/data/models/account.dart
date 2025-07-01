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
