import 'package:chatting_app/ui/contacts/contacts.dart';
import 'package:chatting_app/ui/conversations/conversations.dart';
import 'package:chatting_app/ui/login/login.dart';
import 'package:chatting_app/ui/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  await dotenv.load();
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
        bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedItemColor: Colors.green),
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color.fromRGBO(28, 28, 28, 1.0)),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedItemColor: Colors.green),
        scaffoldBackgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: 
      // SafeArea(child: MyHomePage(title: 'Flutter Demo Home Page')),
      SafeArea(child: LoginPage()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const List<Widget> _tabs = [
    const ConversationsTab(),
    const ContactsTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          activeColor: Colors.green,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Contacts"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ] 
        ), 
        tabBuilder: (context, index) => _tabs[index],),
    );
  }

}
