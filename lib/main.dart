import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/auth/di/auth_providers.dart';
import 'package:pulse_chat/ui/view_models/theme_view_model.dart';
import 'package:pulse_chat/ui/views/contacts/contacts.dart';
import 'package:pulse_chat/ui/views/conversations/conversations.dart';
import 'package:pulse_chat/ui/views/settings/setting.dart';
import 'package:pulse_chat/features/auth/presentation/splash_page/view/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:pulse_chat/core/util/fcm_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // get environment variables
  await dotenv.load();

  // init firebase
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // run app
  final localAuthSource = LocalAuthSource(); // token storage, secure
  final apiClient = ApiClient(localAuthSource); // all network services

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalAuthSource>.value(value: localAuthSource),
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<ThemeViewModel>.value(value: ThemeViewModel()),
        ...authProviders,
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder:
          (context, viewModel, child) => MaterialApp(
            title: '"Pulse Chat"',
            theme: _getBrightThemeData(context, viewModel),
            darkTheme: _getDarkThemeData(context, viewModel),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          ),
    );
  }

  ThemeData _getBrightThemeData(
    BuildContext context,
    ThemeViewModel themeViewModel,
  ) {
    return ThemeData(
      brightness: themeViewModel.currentBrightMode ?? Brightness.light,
      primaryColor: themeViewModel.primaryColor,
      primaryColorDark: themeViewModel.primaryDarkColor,
    );
  }

  ThemeData _getDarkThemeData(
    BuildContext context,
    ThemeViewModel themeViewModel,
  ) {
    return ThemeData(
      brightness: themeViewModel.currentBrightMode ?? Brightness.dark,
      primaryColor: themeViewModel.primaryColor,
      primaryColorDark: themeViewModel.primaryDarkColor,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<Widget> _tabs = [
    ConversationsTab(),
    ContactsTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: Theme.of(context).primaryColorDark,
          backgroundColor: Theme.of(context).colorScheme.surface,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(Icons.chat),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: "Contacts",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
        tabBuilder:
            (context, index) =>
                CupertinoTabView(builder: (context) => _tabs[index]),
      ),
    );
  }
}
