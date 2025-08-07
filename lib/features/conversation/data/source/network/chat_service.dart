import 'package:dio/dio.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/conversation/data/model/message_model.dart';
import 'package:pulse_chat/features/conversation/data/model/message_send_model.dart';
import 'package:pulse_chat/features/conversation/data/model/message_update_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'chat_service.g.dart';

@RestApi()
abstract class ChatService {
  factory ChatService(Dio dio, {String baseUrl, ParseErrorLogger errorLogger}) =
      _ChatService;

  @POST("/groups/{group_id}/messages")
  Future<ObjectResponse<MessageModel>> postGroupMessage(
    @Path("group_id") int groupId,
    @Body() GroupMessageSendModel groupMessage,
  );

  @POST("/messages")
  Future<ObjectResponse<MessageModel>> postDirectMessage(
    @Body() DirectMessageSendModel directMessage,
  );

  @PUT("/messages/{id}")
  Future<ObjectResponse<MessageModel>> putMessage(
    @Path("id") String id,
    @Body() MessageUpdateModel updateMessage,
  );

  @DELETE("/messages/{id}")
  Future<MessageResponse> deleteMessage(@Path("id") String id);
}
