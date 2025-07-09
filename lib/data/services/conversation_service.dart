import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:chatting_app/data/models/conversation.dart';

part 'conversation_api.g.dart';

@RestApi()
abstract class ConversationService {
  factory ConversationService(Dio dio) = _ConversationApi;

  @GET("/users/{userId}/conversations")
  Future<List<Conversation>> getUserConversations(@Path("userId") int userId);

  @GET("/groups/{groupId}/messages/")
  Future<ListResponse<Message>> getGroupMessages(
    @Path("groupId") int groupId,
    @Query("page") int page,
  );

  @GET("/users/{userId}/messages/")
  Future<ListResponse<Message>> getDirectMessages(
    @Path("userId") int userId,
    @Query("other_user_id") int otherUserId,
    @Query("page") int page,
  );
}
