import 'package:pulse_chat/data/models/group_member.dart';
import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part "group_member_service.g.dart";

@RestApi()
abstract class GroupMemberService {
  factory GroupMemberService(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _GroupMemberService;

  // Manage group members
  @GET("/groups/{group_id}/members")
  Future<ListResponse<GroupMember>> getGroupMember(
    @Path("group_id") int groupId,
    @Query("status") int status,
    @Query("page") int page,
  );

  @POST("/groups/{group_id}/members")
  Future<ObjectResponse<GroupMember>> createGroupMember(
    @Path("group_id") int groupId,
    @Body() GroupMemberCreate groupMemberCreate,
  );

  @GET("/groups/{group_id}/members-check")
  Future<ListResponse<GroupMemberCheck>> checkGroupMember(
    @Path("group_id") int groupId,
    @Query("user_ids") List<int> userIds,
  );

  @PUT("/groups/{group_id}/members/{group_member_id}")
  Future<ObjectResponse<GroupMember>> updateGroupMember(
    @Path("group_id") int groupId,
    @Path("group_member_id") int groupMemberId,
    @Body() GroupMemberUpdate groupMemberUpdate,
  );

  @DELETE("/groups/{group_id}/members/{group_member_id}")
  Future<MessageResponse> deleteGroupMember(
    @Path("group_id") int groupId,
    @Path("group_member_id") int groupMemberId,
  );
}
