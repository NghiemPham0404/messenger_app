import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/fcm/data/models/fcm_token.dart';
import 'package:pulse_chat/features/fcm/data/models/fcm_token_create.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'fcm_token_service.g.dart';

@RestApi()
abstract class FcmTokenService {
  factory FcmTokenService(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _FcmTokenService;

  @POST("/fcm_tokens")
  Future<ObjectResponse<FcmTokenModel>> updateFCMToken(
    @Body() FcmTokenCreateModel fcmTokenCreateModel,
  );
}
