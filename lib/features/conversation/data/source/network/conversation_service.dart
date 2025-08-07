import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:pulse_chat/features/conversation/data/model/conversation_model.dart';
import 'package:pulse_chat/features/conversation/data/model/message_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'conversation_service.g.dart';

@RestApi()
abstract class ConversationService {
  factory ConversationService(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _ConversationService;

  @GET("/users/{user_id}/conversations")
  Future<List<ConversationModel>> getUserConversations(
    @Path("user_id") int userId,
  );

  @GET("/groups/{group_id}/messages/")
  Future<ListResponse<MessageModel>> getGroupMessages(
    @Path("group_id") int groupId,
    @Query("page") int page,
  );

  @GET("/users/{user_id}/messages/")
  Future<ListResponse<MessageModel>> getDirectMessages(
    @Path("user_id") int userId,
    @Query("other_user_id") int otherUserId,
    @Query("page") int page,
  );
}
