import 'package:dio/dio.dart';

import 'package:pulse_chat/core/network/auth_interceptor.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/core/network/api_url_provider.dart';

import 'package:pulse_chat/features/conversation/data/source/network/conversation_service.dart';
import 'package:pulse_chat/features/group/data/source/network/group_service.dart';
import 'package:pulse_chat/features/media/data/datasource/network/media_file_service.dart';
import 'package:pulse_chat/features/fcm/data/sources/network/fcm_token_service.dart';
import 'package:pulse_chat/features/auth/data/source/network/auth_service.dart';
import 'package:pulse_chat/features/conversation/data/source/network/chat_service.dart';

import 'package:pulse_chat/features/contact/data/source/network/contact_service.dart';
import 'package:pulse_chat/features/group/data/source/network/group_member_service.dart';
import 'package:pulse_chat/features/user/data/source/network/user_service.dart';

class ApiClient {
  final ApiUrlProvider _apiEndpointProvider = ApiUrlProvider();

  late Dio _dio;

  late Dio _mediaDio;

  ApiClient(LocalAuthSource tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _apiEndpointProvider.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    )..interceptors.add(AuthInterceptor(tokenStorage));

    _mediaDio = Dio(BaseOptions(baseUrl: _apiEndpointProvider.baseUrl))
      ..interceptors.add(AuthInterceptor(tokenStorage));
  }

  AuthService get authApi => AuthService(_dio);

  FcmTokenService get fcmToken => FcmTokenService(_dio);

  ContactService get contactApi => ContactService(_dio);

  ConversationService get conversationApi => ConversationService(_dio);

  ChatService get chatApi => ChatService(_dio);

  GroupService get groupApi => GroupService(_dio);

  GroupMemberService get groupMemberApi => GroupMemberService(_dio);

  MediaFileService get mediaFileApi => MediaFileService(_mediaDio);

  UserService get userApi => UserService(_dio);
}
