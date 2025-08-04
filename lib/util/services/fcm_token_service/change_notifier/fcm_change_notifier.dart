import 'package:chatting_app/util/services/fcm_token_service/models/fcm_token.dart';
import 'package:chatting_app/util/services/fcm_token_service/models/fcm_token_create.dart';
import 'package:chatting_app/util/services/fcm_token_service/repositories/fcm_token_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FCMChangeNotifier extends ChangeNotifier {
  final _fcmRepo = FCMTokenRepoImpl();

  bool _updateStatus = false;
  bool get updateStatus => _updateStatus;

  void updateFCMToken(int userId, String token) async {
    try {
      final fcmTokenCreate = FcmTokenCreateModel(
        token: token,
        userId: userId.toString(),
        updatedAt: DateTime.now(),
      );
      final response = await _fcmRepo.updateToken(fcmTokenCreate);
      _updateStatus = response.success;
    } on DioException catch (e) {
      debugPrint("[FCMToken - Update] : ${e.response!.data["detail"]}");
      _updateStatus = false;
    } finally {
      notifyListeners();
    }
  }

  Future<FCMTokenModel?> getToken() async {
    return _fcmRepo.getToken();
  }
}
