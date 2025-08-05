// ignore_for_file: unused_import

import 'package:pulse_chat/core/network/auth_interceptor.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/data/models/group.dart';
import 'package:pulse_chat/core/network/api_url_provider.dart';
import 'package:pulse_chat/data/services/auth_service.dart';
import 'package:pulse_chat/data/services/contact_service.dart';
import 'package:pulse_chat/data/services/group_member_service.dart';
import 'package:pulse_chat/data/services/group_service.dart';
import 'package:pulse_chat/data/services/media_file_service.dart';
import 'package:pulse_chat/data/services/message_service.dart';
import 'package:pulse_chat/data/services/user_service.dart';
import 'package:pulse_chat/core/util/services/fcm_token_service/datasources/network/api_source.dart';
import 'package:pulse_chat/features/auth/data/source/network/api_auth_source.dart';
import 'package:dio/dio.dart';
import 'package:pulse_chat/data/services/conversation_service.dart';

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

  ApiFCMSource get fcmToken => ApiFCMSource(_dio);

  ContactService get contactApi => ContactService(_dio);

  ConversationService get conversationApi => ConversationService(_dio);

  GroupService get groupApi => GroupService(_dio);

  GroupMemberService get groupMemberApi => GroupMemberService(_dio);

  MediaFileService get mediaFileApi => MediaFileService(_mediaDio);

  MessageService get messageApi => MessageService(_dio);

  UserService get userApi => UserService(_dio);
}
