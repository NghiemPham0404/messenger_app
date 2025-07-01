// ignore_for_file: unused_import

import 'package:chatting_app/data/models/groups.dart';
import 'package:chatting_app/data/network/api_url_provider.dart';
import 'package:chatting_app/data/network/auth_api.dart';
import 'package:chatting_app/data/network/contact_api.dart';
import 'package:chatting_app/data/network/group_api.dart';
import 'package:chatting_app/data/network/message_api.dart';
import 'package:chatting_app/data/network/user_api.dart';
import 'package:dio/dio.dart';
import 'package:chatting_app/data/network/conversation_api.dart';

class AuthApiClient {
  static final ApiUrlProvider _apiEndpointProvider = ApiUrlProvider();
  late final Dio dio;
  AuthApi? _authApi;

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

  AuthApi getAuthApi() {
    return _authApi ?? AuthApi(dio);
  }
}

class ApiClient {
  ApiClient.internal();

  static final ApiClient _instance = ApiClient.internal();

  factory ApiClient() {
    return _instance;
  }

  final ApiUrlProvider _apiEndpointProvider = ApiUrlProvider();
  late Dio _dio;

  late ContactApi _contactApi;
  late ConversationApi _conversationApi;
  late GroupAPI _groupApi;
  late MessageApi _messageApi;
  late UserApi _userApi;

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
    _contactApi = ContactApi(_dio);
    _conversationApi = ConversationApi(_dio);
    _groupApi = GroupAPI(_dio);
    _messageApi = MessageApi(_dio);
    _userApi = UserApi(_dio);
  }

  ContactApi get contactApi => _contactApi;

  ConversationApi get conversationApi => _conversationApi;

  GroupAPI get groupApi => _groupApi;

  MessageApi get messageApi => _messageApi;

  UserApi get userApi => _userApi;
}
