import 'package:pulse_chat/features/fcm/domain/repositories/fcm_repository.dart';

class GetFcmToken {
  final FcmTokenRepository _fcmTokenRepository;

  GetFcmToken(this._fcmTokenRepository);

  Future<String?> call() {
    return _fcmTokenRepository.getFcmToken();
  }
}
