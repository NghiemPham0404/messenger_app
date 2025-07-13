import 'package:chatting_app/ui/view_models/login_view_model.dart';
import 'package:chatting_app/ui/view_models/theme_view_model.dart';
import 'package:chatting_app/ui/views/contacts/contacts.dart';
import 'package:chatting_app/ui/views/conversations/conversations.dart';
import 'package:chatting_app/ui/views/login/login.dart';
import 'package:chatting_app/ui/views/settings/setting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeViewModel(),
      child: Consumer<ThemeViewModel>(
        builder:
            (context, viewModel, child) => MaterialApp(
              title: 'Messenger',
              theme: _getBrightThemeData(context, viewModel),
              darkTheme: _getDarkThemeData(context, viewModel),
              home: SafeArea(
                child: ChangeNotifierProvider(
                  create: (_) => LoginViewModel(),
                  child: const LoginPage(),
                ),
              ),
              debugShowCheckedModeBanner: false,
            ),
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
