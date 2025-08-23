import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/signup.dart';

part 'signup_model.g.dart';

@JsonSerializable()
class SignUpModel extends SignUp {
  SignUpModel({
    required super.email,
    required super.name,
    required super.password,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}
