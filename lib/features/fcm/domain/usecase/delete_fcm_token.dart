import 'package:pulse_chat/features/fcm/domain/repositories/fcm_repository.dart';

class DeleteFcmToken {
  final FcmTokenRepository _fcmTokenRepository;

  DeleteFcmToken(this._fcmTokenRepository);

  Future<void> call() {
    return _fcmTokenRepository.delete();
  }
}
