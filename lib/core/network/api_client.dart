import 'package:pulse_chat/core/network/auth_interceptor.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/media/data/datasource/network/media_file_api.dart';
import 'package:pulse_chat/core/network/api_url_provider.dart';
import 'package:pulse_chat/data/services/contact_service.dart';
import 'package:pulse_chat/data/services/group_member_service.dart';
import 'package:pulse_chat/data/services/group_service.dart';
import 'package:pulse_chat/data/services/user_service.dart';
import 'package:pulse_chat/features/fcm/data/sources/network/api_source.dart';
import 'package:pulse_chat/features/auth/data/source/network/api_auth_source.dart';
import 'package:dio/dio.dart';
import 'package:pulse_chat/features/conversation/data/source/network/chat_service.dart';

import '../../features/conversation/data/source/network/conversation_service.dart';

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

  ApiAuthSource get authApi => ApiAuthSource(_dio);

  ApiFcmTokenSource get fcmToken => ApiFcmTokenSource(_dio);

  ContactService get contactApi => ContactService(_dio);

  ConversationService get conversationApi => ConversationService(_dio);

  ChatService get chatApi => ChatService(_dio);

  GroupService get groupApi => GroupService(_dio);

  GroupMemberService get groupMemberApi => GroupMemberService(_dio);

  MediaFileApiSource get mediaFileApi => MediaFileApiSource(_mediaDio);

  UserService get userApi => UserService(_dio);
}
