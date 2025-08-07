import 'package:json_annotation/json_annotation.dart';

part 'object_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ObjectResponse<T> {
  @JsonKey(name: 'result')
  T result;

  @JsonKey(name: 'success')
  bool success = false;

  ObjectResponse({required this.result, required this.success});

  factory ObjectResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ObjectResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Function(T) toJson) =>
      _$ObjectResponseToJson(this, toJson);
}
