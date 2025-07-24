// ignore_for_file: unused_import

import 'package:chatting_app/data/models/group.dart';
import 'package:chatting_app/data/network/api_url_provider.dart';
import 'package:chatting_app/data/services/auth_service.dart';
import 'package:chatting_app/data/services/contact_service.dart';
import 'package:chatting_app/data/services/group_member_service.dart';
import 'package:chatting_app/data/services/group_service.dart';
import 'package:chatting_app/data/services/media_file_service.dart';
import 'package:chatting_app/data/services/message_service.dart';
import 'package:chatting_app/data/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:chatting_app/data/services/conversation_service.dart';

class AuthApiClient {
  static final ApiUrlProvider _apiEndpointProvider = ApiUrlProvider();
  late final Dio dio;
  AuthService? _authApi;

  AuthApiClient.internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: _apiEndpointProvider.baseUrl, // hoặc dotenv
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  static final AuthApiClient _instance = AuthApiClient.internal();

  factory AuthApiClient() => _instance;

  AuthService getAuthApi() {
    return _authApi ?? AuthService(dio);
  }
}

class ApiClient {
  ApiClient.internal();

  static final ApiClient _instance = ApiClient.internal();

  factory ApiClient() {
    return _instance;
  }

  final ApiUrlProvider _apiEndpointProvider = ApiUrlProvider();
  Dio? _dio;

  ContactService? _contactApi;
  ConversationService? _conversationApi;
  GroupService? _groupApi;
  GroupMemberService? _groupMemberService;
  MediaFileService? _mediaFileService;
  MessageService? _messageApi;
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
    _conversationApi = ConversationService(_dio!);
    _groupApi = GroupService(_dio!);
    _groupMemberService = GroupMemberService(_dio!);
    _messageApi = MessageService(_dio!);
    _userApi = UserService(_dio!);

    _initMediaFileService(accessToken);
  }

  void destroy() {
    _dio = null;
    _contactApi = null;
    _conversationApi = null;
    _groupApi = null;
    _groupMemberService = null;
    _mediaFileService = null;
    _messageApi = null;
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

  ConversationService get conversationApi {
    if (_conversationApi == null) {
      throw Exception(
        'conversation api not initialized. Call initialize() first.',
      );
    }
    return _conversationApi!;
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

  MessageService get messageApi {
    if (_messageApi == null) {
      throw Exception(
        'message api service not initialized. Call initialize() first.',
      );
    }
    return _messageApi!;
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
