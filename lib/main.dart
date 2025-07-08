import 'package:chatting_app/ui/view_models/login_view_model.dart';
import 'package:chatting_app/ui/views/contacts/contacts.dart';
import 'package:chatting_app/ui/views/conversations/conversations.dart';
import 'package:chatting_app/ui/views/login/login.dart';
import 'package:chatting_app/ui/views/settings/settings.dart';
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
    return MaterialApp(
      title: 'Messenger',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: const Color.fromRGBO(76, 175, 80, 1),
        ),
        primaryColor: Colors.green,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color.fromRGBO(28, 28, 28, 1.0)),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
        ),
        scaffoldBackgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
          child: const LoginPage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          activeColor: Colors.green,
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
