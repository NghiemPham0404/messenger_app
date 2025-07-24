import 'package:chatting_app/data/models/group.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:chatting_app/data/responses/message_response.dart';
import 'package:chatting_app/data/responses/object_response.dart';
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

  @POST("/groups/")
  Future<ObjectResponse<Group>> createGroup(@Body() GroupCreate groupCreate);

  @GET("/groups/{id}")
  Future<ObjectResponse<Group>> getGroup(@Path("id") int id);

  @PUT("/groups/{id}")
  Future<ObjectResponse<Group>> updateGroup(
    @Path("id") int id,
    @Body() GroupUpdate groupUpdate,
  );

  @DELETE("/groups/{id}")
  Future<MessageResponse> deleteGroup(@Path("id") int id);
}
