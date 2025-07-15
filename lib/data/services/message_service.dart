import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/responses/message_response.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'message_service.g.dart';

@RestApi()
abstract class MessageService {
  factory MessageService(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _MessageService;

  @POST("/groups/{group_id}/messages")
  Future<ObjectResponse<Message>> postGroupMessage(
    @Path("group_id") int groupId,
    @Body() GroupMessageCreate groupMessage,
  );

  @POST("/messages")
  Future<ObjectResponse<Message>> postDirectMessage(
    @Body() DirectMessageCreate directMessage,
  );

  @PUT("/messages/{id}")
  Future<ObjectResponse<Message>> putMessage(
    @Path("id") String id,
    @Body() MessageUpdate updateMessage,
  );

  @DELETE("/messages/{id}")
  Future<MessageResponse> deleteMessage(@Path("id") String id);
}
