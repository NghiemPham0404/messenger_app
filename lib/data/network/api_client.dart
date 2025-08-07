// ignore_for_file: unused_import

import 'package:pulse_chat/data/models/group.dart';
import 'package:pulse_chat/data/network/api_url_provider.dart';
import 'package:pulse_chat/data/services/contact_service.dart';
import 'package:pulse_chat/data/services/group_member_service.dart';
import 'package:pulse_chat/data/services/group_service.dart';
import 'package:pulse_chat/data/services/media_file_service.dart';
import 'package:pulse_chat/data/services/user_service.dart';
import 'package:dio/dio.dart';

class ApiClient {
  ApiClient.internal();

  static final ApiClient _instance = ApiClient.internal();

  factory ApiClient() {
    return _instance;
  }

  final ApiUrlProvider _apiEndpointProvider = ApiUrlProvider();
  Dio? _dio;

  ContactService? _contactApi;
  GroupService? _groupApi;
  GroupMemberService? _groupMemberService;
  MediaFileService? _mediaFileService;
  UserService? _userApi;

  void initialize(String accessToken) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _apiEndpointProvider.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    _contactApi = ContactService(_dio!);
    _groupApi = GroupService(_dio!);
    _groupMemberService = GroupMemberService(_dio!);

    _userApi = UserService(_dio!);
    _initMediaFileService(accessToken);
  }

  void destroy() {
    _dio = null;
    _contactApi = null;
    _groupApi = null;
    _groupMemberService = null;
    _mediaFileService = null;
    _userApi = null;
  }

  ContactService get contactApi {
    if (_contactApi == null) {
      throw Exception(
        'contact api service not initialized. Call initialize() first.',
      );
    }
    return _contactApi!;
  }

  GroupService get groupApi {
    if (_groupApi == null) {
      throw Exception('groupApi initialized. Call initialize() first.');
    }
    return _groupApi!;
  }

  GroupMemberService get groupMemberApi {
    if (_groupApi == null) {
      throw Exception('groupApi initialized. Call initialize() first.');
    }
    return _groupMemberService!;
  }

  MediaFileService get mediaFileApi {
    if (_mediaFileService == null) {
      throw Exception(
        'mediaFile api service not initialized. Call initialize() first.',
      );
    }
    return _mediaFileService!;
  }

  UserService get userApi {
    if (_userApi == null) {
      throw Exception(
        'user api service not initialized. Call initialize() first.',
      );
    }
    return _userApi!;
  }

  void _initMediaFileService(String accessToken) {
    final mediaDio = Dio(
      BaseOptions(
        baseUrl: _apiEndpointProvider.baseUrl,
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    mediaDio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
    _mediaFileService = MediaFileService(mediaDio);
  }
}
