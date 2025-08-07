import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/fcm/data/models/fcm_token.dart';
import 'package:pulse_chat/features/fcm/data/models/fcm_token_create.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_source.g.dart';

@RestApi()
abstract class ApiFcmTokenSource {
  factory ApiFcmTokenSource(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _ApiFcmTokenSource;

  @POST("/fcm_tokens")
  Future<ObjectResponse<FcmTokenModel>> updateFCMToken(
    @Body() FcmTokenCreateModel fcmTokenCreateModel,
  );
}
