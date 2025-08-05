import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/responses/object_response.dart';
import 'package:pulse_chat/core/util/services/fcm_token_service/datasources/local/local_source.dart';
import 'package:pulse_chat/core/util/services/fcm_token_service/models/fcm_token.dart';
import 'package:pulse_chat/core/util/services/fcm_token_service/models/fcm_token_create.dart';
import 'package:flutter/cupertino.dart';

class FCMTokenRepoImpl {
  final ApiClient apiClient;

  late final LocalFCMDatasource localFCMDatasource = LocalFCMDatasource();

  FCMTokenRepoImpl({required this.apiClient});

  Future<ObjectResponse<FCMTokenModel>> updateToken(
    FcmTokenCreateModel fcmTokenCreate,
  ) async {
    final fcmTokenCreateModel = FcmTokenCreateModel(
      token: fcmTokenCreate.token,
      userId: fcmTokenCreate.userId,
      updatedAt: fcmTokenCreate.updatedAt,
    );
    final response = await apiClient.fcmToken.updateFCMToken(
      fcmTokenCreateModel,
    );
    if (response.success == true) {
      debugPrint("[FCM TOKEN - Update] : success");
      localFCMDatasource.updateFCMToken(response.result!);
    }
    return response;
  }

  Future<FCMTokenModel?> getToken() async {
    return await localFCMDatasource.getFCMToken();
  }
}
