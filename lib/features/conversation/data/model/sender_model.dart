import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/conversation/domain/entities/sender.dart';

part 'sender_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SenderModel extends Sender {
  SenderModel({required super.id, required super.name, required super.avatar});

  factory SenderModel.fromJson(Map<String, dynamic> json) =>
      _$SenderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SenderModelToJson(this);
}
