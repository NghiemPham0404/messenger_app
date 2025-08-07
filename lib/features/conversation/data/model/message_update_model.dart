import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_update.dart';

part 'message_update_model.g.dart';

@JsonSerializable()
class MessageUpdateModel extends MessageUpdate {
  MessageUpdateModel({required super.content});

  factory MessageUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$MessageUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageUpdateModelToJson(this);
}
