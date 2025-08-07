import 'package:pulse_chat/app/my_app.dart';
import 'package:pulse_chat/features/notification/local_notification_service.dart';
import 'package:pulse_chat/ui/view_models/contact_view_model.dart';
import 'package:pulse_chat/ui/view_models/group_view_model.dart';
import 'package:pulse_chat/features/auth/presentation/splash_page/change_notifier/splash_notifier.dart';
import 'package:pulse_chat/features/auth/presentation/login_page/view/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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
  late SplashNotifier splashNotifier;

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
      splashNotifier = Provider.of<SplashNotifier>(context, listen: false);

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          tryRelogin();
        }
      });

      initApp();
    });
  }

  void initApp() async {
    // init firebase- messaging
    await LocalNotificationService.requestNotificationPermission();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("[FCM TOKEN] $fcmToken");

    // init hive
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  /// Try to log user in with the previous saved token
  void tryRelogin() {
    splashNotifier.reLogin(() => navigateToHome(), () => navigateToLogin());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          isDarkMode
                              ? null
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                    child: Image.asset("assets/images/app_logo.png", width: 64),
                  ),
                  Text(
                    "Pulse Chat",
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
              ChangeNotifierProvider(create: (_) => ContactViewModel()),
              ChangeNotifierProvider(create: (_) => GroupViewModel()),
            ],
            child: const MyHomePage(),
          );
        },
      ),
    );
  }

  void navigateToLogin() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacement(CupertinoPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
