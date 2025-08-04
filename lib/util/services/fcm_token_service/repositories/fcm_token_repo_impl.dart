import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:chatting_app/util/services/fcm_token_service/datasources/local/local_source.dart';
import 'package:chatting_app/util/services/fcm_token_service/models/fcm_token.dart';
import 'package:chatting_app/util/services/fcm_token_service/models/fcm_token_create.dart';
import 'package:flutter/cupertino.dart';

class FCMTokenRepoImpl {
  final ApiClient _apiClient = ApiClient();

  late final LocalFCMDatasource localFCMDatasource = LocalFCMDatasource();

  FCMTokenRepoImpl.internal();

  static final FCMTokenRepoImpl _instance = FCMTokenRepoImpl.internal();

  factory FCMTokenRepoImpl() => _instance;

  Future<ObjectResponse<FCMTokenModel>> updateToken(
    FcmTokenCreateModel fcmTokenCreate,
  ) async {
    final fcmTokenCreateModel = FcmTokenCreateModel(
      token: fcmTokenCreate.token,
      userId: fcmTokenCreate.userId,
      updatedAt: fcmTokenCreate.updatedAt,
    );
    final response = await _apiClient.fcmToken.updateFCMToken(
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
