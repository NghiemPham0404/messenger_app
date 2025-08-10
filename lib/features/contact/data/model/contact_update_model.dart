import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact_update.dart';

part 'contact_update_model.g.dart';

@JsonSerializable()
class ContactUpdateModel extends ContactUpdate {
  ContactUpdateModel({required super.action});

  factory ContactUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$ContactUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactUpdateModelToJson(this);
}
