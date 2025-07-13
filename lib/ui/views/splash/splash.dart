import 'package:chatting_app/main.dart';
import 'package:chatting_app/ui/view_models/contact_view_model.dart';
import 'package:chatting_app/ui/view_models/conversations_view_model.dart';
import 'package:chatting_app/ui/view_models/group_view_model.dart';
import 'package:chatting_app/ui/view_models/login_view_model.dart';
import 'package:chatting_app/ui/view_models/setting_view_model.dart';
import 'package:chatting_app/ui/view_models/splash_view_model.dart';
import 'package:chatting_app/ui/views/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late SplashScreenViewModel splashScreenViewModel;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashScreenViewModel = Provider.of<SplashScreenViewModel>(
        context,
        listen: false,
      );

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          tryRelogin();
        }
      });
    });
  }

  /// Try to log user in with the previous saved token
  void tryRelogin() {
    splashScreenViewModel.reLogin(
      () => navigateToHome(),
      () => navigateToLogin(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/app_logo.png",
                    width: 86,
                    height: 86,
                  ),
                  Text(
                    "Messenger app",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ConversationsViewModel()),
              ChangeNotifierProvider(create: (_) => ContactViewModel()),
              ChangeNotifierProvider(create: (_) => GroupViewModel()),
              ChangeNotifierProvider(create: (_) => SettingsViewModel()),
            ],
            child: const MyHomePage(),
          );
        },
      ),
    );
  }

  void navigateToLogin() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      CupertinoPageRoute(
        builder:
            (context) => ChangeNotifierProvider(
              create: (_) => LoginViewModel(),
              child: LoginPage(),
            ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
