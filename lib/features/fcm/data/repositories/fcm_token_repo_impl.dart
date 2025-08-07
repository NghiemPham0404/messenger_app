import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/fcm/data/sources/local/local_source.dart';
import 'package:pulse_chat/features/fcm/data/models/fcm_token_create.dart';
import 'package:pulse_chat/features/fcm/data/sources/network/api_source.dart';
import 'package:pulse_chat/features/fcm/domain/entities/fcm_token.dart';
import 'package:pulse_chat/features/fcm/domain/repositories/fcm_repository.dart';

class FCMTokenRepoImpl implements FcmTokenRepository {
  final LocalFCMDatasource _localFCMDatasource;

  final ApiFcmTokenSource _apiFcmTokenSource;

  final LocalAuthSource _localAuthSource;

  FCMTokenRepoImpl({
    required LocalFCMDatasource localFCMDatasource,
    required ApiFcmTokenSource apiFcmTokenSource,
    required LocalAuthSource localAuthSource,
  }) : _localFCMDatasource = localFCMDatasource,
       _apiFcmTokenSource = apiFcmTokenSource,
       _localAuthSource = localAuthSource;

  @override
  Future<ObjectResponse<FcmToken>> createFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    final userId = _localAuthSource.getCachedUser()?.id;

    if (token != null && userId != null) {
      final fcmTokenCreateModel = FcmTokenCreateModel(
        token: token,
        userId: userId,
        updatedAt: DateTime.now(),
      );
      final response = await _apiFcmTokenSource.updateFCMToken(
        fcmTokenCreateModel,
      );
      _localFCMDatasource.updateFCMToken(response.result.token);
      return response;
    } else {
      throw {"detail": "fail to create fcmtoken in server"};
    }
  }

  @override
  Future<String?> getFcmToken() {
    return _localFCMDatasource.getFCMToken();
  }

  @override
  Future<void> delete() async {
    final token = await getFcmToken();
    if (token != null) {
      _localFCMDatasource.deleteFCMToken();
    }
  }
}
