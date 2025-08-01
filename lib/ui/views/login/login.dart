import 'package:chatting_app/main.dart';
import 'package:chatting_app/ui/view_models/contact_view_model.dart';
import 'package:chatting_app/ui/view_models/conversations_view_model.dart';
import 'package:chatting_app/ui/view_models/group_view_model.dart';
import 'package:chatting_app/ui/view_models/login_view_model.dart';
import 'package:chatting_app/ui/view_models/setting_view_model.dart';
import 'package:chatting_app/ui/views/signup/signup.dart';
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

  late LoginViewModel loginViewModel;

  @override
  void initState() {
    super.initState();
    _hidePasssword = true;
    demo();

    loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    observeChange();
  }

  void observeChange() {
    loginViewModel.getCurrentUser().listen((currentUser) {
      if (currentUser != null) {
        navigateToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
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

  Widget _loginForm(BuildContext context, LoginViewModel viewModel) {
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
          "Messenger app",
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

  Widget _getError(LoginViewModel viewModel) {
    return viewModel.errorMessage == null
        ? SizedBox.shrink()
        : Text(viewModel.errorMessage!, style: TextStyle(color: Colors.red));
  }

  Widget _getLoginButton(LoginViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        // gradient:
        //     viewModel.isLoading
        //         ? LinearGradient(
        //           colors: [
        //             Theme.of(context).disabledColor,
        //             Theme.of(context).disabledColor,
        //           ],
        //         )
        //         : LinearGradient(
        //           colors: [
        //             Theme.of(context).primaryColor,
        //             Theme.of(context).primaryColorDark,
        //           ],
        //         ),
        color:
            viewModel.isLoading
                ? Theme.of(context).disabledColor
                : Theme.of(context).colorScheme.onSurface,
      ),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          onPressed: () => viewModel.isLoading ? null : handleLogin(viewModel),
          child: Text(
            viewModel.isLoading ? "Loadding..." : "Login",
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

  Widget _getOtherLoginMethods(LoginViewModel viewModel) {
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

  void handleLogin(LoginViewModel viewModel) {
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

  void handleGoogleSignIn(LoginViewModel viewModel) {
    viewModel.loginByGoogle();
  }
}
