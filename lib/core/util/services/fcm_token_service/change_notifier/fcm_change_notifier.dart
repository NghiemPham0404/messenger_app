import 'package:pulse_chat/core/util/services/fcm_token_service/models/fcm_token.dart';
import 'package:pulse_chat/core/util/services/fcm_token_service/models/fcm_token_create.dart';
import 'package:pulse_chat/core/util/services/fcm_token_service/repositories/fcm_token_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FCMChangeNotifier extends ChangeNotifier {
  FCMTokenRepoImpl fcmRepo;

  FCMChangeNotifier({required this.fcmRepo});

  bool _updateStatus = false;
  bool get updateStatus => _updateStatus;

  void updateFCMToken(int userId, String token) async {
    try {
      final fcmTokenCreate = FcmTokenCreateModel(
        token: token,
        userId: userId.toString(),
        updatedAt: DateTime.now(),
      );
      final response = await fcmRepo.updateToken(fcmTokenCreate);
      _updateStatus = response.success;
    } on DioException catch (e) {
      debugPrint("[FCMToken - Update] : ${e.response!.data["detail"]}");
      _updateStatus = false;
    } finally {
      notifyListeners();
    }
  }

  Future<FCMTokenModel?> getToken() async {
    return fcmRepo.getToken();
  }
}
