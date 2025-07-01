import 'package:chatting_app/data/models/groups.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part "group_api.g.dart";

@RestApi()
abstract class GroupAPI {
  factory GroupAPI(Dio dio) = _GroupAPI;

  @GET("/groups")
  Future<ListResponse<Group>> getGroups(
    @Query("keyword") String keyword,
    @Query("page") int page,
  );
}
