import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:dio/dio.dart';
import 'package:pulse_chat/features/group/data/model/group_create_model.dart';
import 'package:pulse_chat/features/group/data/model/group_model.dart';
import 'package:pulse_chat/features/group/data/model/group_update_model.dart';
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
  Future<ListResponse<GroupModel>> getGroups(
    @Query("keyword") String keyword,
    @Query("page") int page,
  );

  @POST("/groups/")
  Future<ObjectResponse<GroupModel>> createGroup(
    @Body() GroupCreateModel groupCreate,
  );

  @GET("/groups/{id}")
  Future<ObjectResponse<GroupModel>> getGroup(@Path("id") int id);

  @GET("/users/{id}/groups")
  Future<ListResponse<GroupModel>> fetchUserGroup(
    @Path("id") int id,
    @Query("status") int status,
    @Query("page") int page,
  );

  @PUT("/groups/{id}")
  Future<ObjectResponse<GroupModel>> updateGroup(
    @Path("id") int id,
    @Body() GroupUpdateModel groupUpdate,
  );

  @DELETE("/groups/{id}")
  Future<MessageResponse> deleteGroup(@Path("id") int id);
}
