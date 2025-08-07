import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_chat/features/auth/presentation/splash_page/view/splash.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/conversation_page/view/conversation_page.dart';
import 'package:pulse_chat/features/fcm/domain/usecase/create_fcm_token.dart';
import 'package:pulse_chat/features/fcm/domain/usecase/get_fcm_token.dart';
import 'package:pulse_chat/features/setting/presentation/view/setting_page.dart';
import 'package:pulse_chat/features/theme/presentation/notifier/theme_notifier.dart';
import 'package:pulse_chat/ui/views/contacts/contacts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
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
    ThemeNotifier themeViewModel,
  ) {
    return ThemeData(
      brightness: themeViewModel.currentBrightMode ?? Brightness.light,
      primaryColor: themeViewModel.primaryColor,
      primaryColorDark: themeViewModel.primaryDarkColor,
    );
  }

  ThemeData _getDarkThemeData(
    BuildContext context,
    ThemeNotifier themeViewModel,
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

  late final StreamSubscription<String> _tokenRefreshSub;

  @override
  void initState() {
    super.initState();
    _updateFcmToken();

    _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen((
      token,
    ) {
      _updateFcmToken();
    });
  }

  Future<void> _updateFcmToken() async {
    final getFcmToken = Provider.of<GetFcmToken>(context, listen: false);
    final createFcmToken = Provider.of<CreateFcmToken>(context, listen: false);
    final fcmToken = await getFcmToken();
    if (fcmToken == null) {
      createFcmToken();
    }
  }

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

  @override
  void dispose() {
    _tokenRefreshSub.cancel();
    super.dispose();
  }
}
