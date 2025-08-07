import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/fcm/domain/entities/fcm_token.dart';
import 'package:pulse_chat/features/fcm/domain/repositories/fcm_repository.dart';

class CreateFcmToken {
  final FcmTokenRepository _fcmTokenRepository;

  CreateFcmToken(this._fcmTokenRepository);

  Future<ObjectResponse<FcmToken>> call() {
    return _fcmTokenRepository.createFcmToken();
  }
}
