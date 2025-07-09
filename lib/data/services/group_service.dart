import 'package:chatting_app/data/models/groups.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part "group_service.g.dart";

@RestApi()
abstract class GroupService {
  factory GroupService(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _GroupService;

  @GET("/groups")
  Future<ListResponse<Group>> getGroups(
    @Query("keyword") String keyword,
    @Query("page") int page,
  );
}
