import 'package:pulse_chat/app/my_app.dart';
import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/conversation/di/socket_provider.dart';
import 'package:pulse_chat/features/fcm/di/fcm_token_provider.dart';
import 'package:pulse_chat/features/media/di/media_file_providers.dart';
import 'package:pulse_chat/features/auth/di/auth_providers.dart';
import 'package:pulse_chat/features/conversation/di/conversation_provider.dart';
import 'package:pulse_chat/features/setting/di/setting_providers.dart';
import 'package:pulse_chat/features/theme/di/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:pulse_chat/core/firebase/fcm_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // get environment variables
  await dotenv.load();

  // init firebase
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);

  // run app
  final localAuthSource = LocalAuthSource(); // token storage, secure
  final apiClient = ApiClient(localAuthSource); // all network services

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalAuthSource>.value(value: localAuthSource),
        Provider<ApiClient>.value(value: apiClient),
        ...themeProviders,
        ...authProviders,
        ...fcmTokenProviders,
        ...socketProviders,
        ...conversationsProviders,
        ...mediaFileProviders,
        ...settingProviders,
      ],
      child: MyApp(),
    ),
  );
}
