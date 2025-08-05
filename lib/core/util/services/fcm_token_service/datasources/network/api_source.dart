import 'package:pulse_chat/core/network/responses/object_response.dart';
import 'package:pulse_chat/core/util/services/fcm_token_service/models/fcm_token.dart';
import 'package:pulse_chat/core/util/services/fcm_token_service/models/fcm_token_create.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_source.g.dart';

@RestApi()
abstract class ApiFCMSource {
  factory ApiFCMSource(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _ApiFCMSource;

  @POST("/fcm_tokens")
  Future<ObjectResponse<FCMTokenModel>> updateFCMToken(
    @Body() FcmTokenCreateModel fcmTokenCreateModel,
  );
}
