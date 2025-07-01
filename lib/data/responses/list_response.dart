import 'package:json_annotation/json_annotation.dart';

part 'list_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ListResponse<T> {
  @JsonKey(name: 'results')
  List<T>? results;

  @JsonKey(name: 'success')
  bool? success;

  @JsonKey(name: 'page')
  int? page;

  @JsonKey(name: 'total_pages')
  int? totalPages;

  @JsonKey(name: 'total_results')
  int? totalResults;

  ListResponse({
    this.results,
    this.success,
    this.page,
    this.totalPages,
    this.totalResults,
  });

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ListResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ListResponseToJson(this, toJsonT);
}
