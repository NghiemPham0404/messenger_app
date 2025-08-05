import 'package:pulse_chat/core/util/page_state.dart';
import 'package:pulse_chat/main.dart';
import 'package:pulse_chat/ui/view_models/contact_view_model.dart';
import 'package:pulse_chat/ui/view_models/conversations_view_model.dart';
import 'package:pulse_chat/ui/view_models/group_view_model.dart';
import 'package:pulse_chat/features/auth/presentation/login_page/change_notifier/login_notifier.dart';
import 'package:pulse_chat/ui/view_models/setting_view_model.dart';
import 'package:pulse_chat/features/auth/presentation/signup_page/view/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  late bool _hidePasssword;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginNotifier loginViewModel;

  @override
  void initState() {
    super.initState();
    _hidePasssword = true;
    demo();

    loginViewModel = Provider.of<LoginNotifier>(context, listen: false);

    observeChange();
  }

  void observeChange() {
    loginViewModel.getCurrentUser().listen((currentUser) {
      if (currentUser != null) {
        updateFCMToken(currentUser.id);
        navigateToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (context, viewModel, child) {
        loginViewModel = loginViewModel;
        return CupertinoPageScaffold(
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(child: _loginForm(context, viewModel)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loginForm(BuildContext context, LoginNotifier viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _appIconHeader(),
          SizedBox(height: 32),
          _myEmailField(),
          SizedBox(height: 12),
          _myPasswordField(),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              onPressed: () {},
              child: Text(
                "Forgot password ?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          _getError(viewModel),
          _getLoginButton(viewModel),
          SizedBox(height: 32),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: Divider(
                  color: Theme.of(context).colorScheme.outline,
                  thickness: 1,
                ),
              ),
              Text("or"),
              Expanded(
                child: Divider(
                  color: Theme.of(context).colorScheme.outline,
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _getOtherLoginMethods(viewModel),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account ?"),
              TextButton(
                onPressed: () => navigateToSignUpScreen(context),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appIconHeader() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        SizedBox(height: 64),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDarkMode ? null : Theme.of(context).colorScheme.onSurface,
          ),
          child: Image.asset("assets/images/app_logo.png", width: 48),
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
    );
  }

  Widget _myEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        suffix: Icon(Icons.person),
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _myPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffix: IconButton(
          onPressed: handleHidePassword,
          icon: Icon(getRevealPasswordIcon()),
        ),
      ),
      obscureText: _hidePasssword,
    );
  }

  IconData getRevealPasswordIcon() {
    return _hidePasssword
        ? CupertinoIcons.eye_fill
        : CupertinoIcons.eye_slash_fill;
  }

  Widget _getError(LoginNotifier viewModel) {
    return viewModel.errorMessage == null
        ? SizedBox.shrink()
        : Text(viewModel.errorMessage!, style: TextStyle(color: Colors.red));
  }

  Widget _getLoginButton(LoginNotifier loginNotifier) {
    bool isLoading = loginNotifier.pageState == PageState.loading;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color:
            isLoading
                ? Theme.of(context).disabledColor
                : Theme.of(context).colorScheme.onSurface,
      ),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          onPressed: () => isLoading ? null : handleLogin(loginNotifier),
          child: Text(
            isLoading ? "Loadding..." : "Login",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getOtherLoginMethods(LoginNotifier viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        GestureDetector(
          onTap: () => handleGoogleSignIn(viewModel),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: SvgPicture.asset(
                'assets/images/google-color-svgrepo-com.svg',
              ),
            ),
          ),
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),

            child: SvgPicture.asset('assets/images/facebook-svgrepo-com.svg'),
          ),
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),

            child: SvgPicture.asset('assets/images/apple-173-svgrepo-com.svg'),
          ),
        ),
      ],
    );
  }

  void handleHidePassword() {
    setState(() {
      _hidePasssword = !_hidePasssword;
    });
  }

  void handleLogin(LoginNotifier viewModel) {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    viewModel.login(email, password);
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
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

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return SignUpScreen();
        },
      ),
    );
  }

  void demo() {
    _emailController.text = dotenv.env['username'] ?? 'alice.smit@gmail.com';
    _passwordController.text = "123123";
  }

  void handleGoogleSignIn(LoginNotifier viewModel) {
    viewModel.loginByGoogle();
  }

  void updateFCMToken(int id) async {
    // final fcmChangeNotifier = FCMChangeNotifier();
    // final currentTokenModel = await fcmChangeNotifier.getToken();
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && currentTokenModel?.token != fcmToken) {
    //   fcmChangeNotifier.updateFCMToken(id, fcmToken);
    // }
  }
}
