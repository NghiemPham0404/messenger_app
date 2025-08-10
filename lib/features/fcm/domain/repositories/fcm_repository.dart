import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/fcm/domain/entities/fcm_token.dart';

abstract class FcmTokenRepository {
  Future<ObjectResponse<FcmToken>> createFcmToken(String token);
  Future<String?> getFcmToken();

  Future<void> delete();
}
