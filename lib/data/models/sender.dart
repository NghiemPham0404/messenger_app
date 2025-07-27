import 'package:json_annotation/json_annotation.dart';

part 'sender.g.dart';

@JsonSerializable(explicitToJson: true)
class Sender {
  late int id;
  late String name;
  late String avatar;

  Sender(this.id, this.name, this.avatar);

  factory Sender.fromJson(Map<String, dynamic> json) => _$SenderFromJson(json);

  Map<String, dynamic> toJson() => _$SenderToJson(this);
}
