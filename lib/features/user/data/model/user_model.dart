import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/user/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
