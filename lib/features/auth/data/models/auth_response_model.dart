import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_res.dart';

@JsonSerializable()
class AuthResponseModel extends AuthResponse {
  AuthResponseModel({
    required super.accessToken,
    required super.bearerType,
    required super.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> map) {
    return AuthResponseModel(
      accessToken: map['access_token'],
      refreshToken: map['refresh_token'],
      bearerType: map['token_type'],
    );
  }
}
