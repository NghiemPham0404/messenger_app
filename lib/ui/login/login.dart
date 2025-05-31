import 'package:chatting_app/main.dart';
import 'package:chatting_app/ui/view_models/login_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
  
}

class LoginPageState extends State<LoginPage>{
  late bool _isDarkMode;
  late bool _hidePasssword;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginViewModel _loginViewModel = LoginViewModel();

  @override
  void initState(){
    super.initState();
    _hidePasssword = true;
    demo();
  }
  
  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return CupertinoPageScaffold(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 64,),
                  SizedBox(
                    width: 128,
                    height: 128,
                    child: Image(image: AssetImage("assets/images/app_logo.png")),
                  ),
                  Center(child: Text("Messenger app", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25),)),
                  SizedBox(height: 32,),
                  _myEmailField(),
                  _myPasswordField(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      onPressed: (){}, 
                      child: Text("Forgot password ?", style: TextStyle(color: Theme.of(context).primaryColor))
                      )
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(color: Theme.of(context).primaryColor, onPressed: handleLogin, child: Text("Login"),)),
                  ),
                  SizedBox(height: 32,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      spacing: 10,
                      children: [
                        Expanded(child: Divider(color: Colors.black, thickness: 1,)),
                        Text("or", style: TextStyle(color: CupertinoColors.black),),
                        Expanded(child: Divider(color: Colors.black, thickness: 1,)),
                      ],
                    ),
                  ),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 84,
                        height: 84,
                        child: IconButton(
                          onPressed: (){}, 
                          icon: Image.network(
                            "https://res.cloudinary.com/ddkyyleic/image/upload/v1744279604/4rgcd9p1_expires_30_days_b7zug2.png"
                            )
                        ),
                      ),
                      SizedBox(
                        width: 84,
                        height: 84,
                        child: IconButton(
                          onPressed: (){}, 
                          icon: Image.network(
                            "https://res.cloudinary.com/ddkyyleic/image/upload/v1744279604/k32ragwy_expires_30_days_kxc9wq.png"
                          )
                        ),
                      ),
            
                      SizedBox(
                        width: 84,
                        height: 84,
                        child: IconButton(
                          onPressed: (){}, 
                          icon: Image.network(
                          "https://res.cloudinary.com/ddkyyleic/image/upload/v1744279604/faa5mxdr_expires_30_days_juh7ys.png"
                          )
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont have an account ?", style: TextStyle(color: Colors.black, fontSize: 18),),
                      TextButton(onPressed: (){}, 
                      child: 
                        Text("Sign up", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                      )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
  Widget _myEmailField(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
      child: CupertinoTextField(
        controller: _emailController,
        padding: EdgeInsets.all(16),
        placeholder: 'Email',          // <-- hint text
        placeholderStyle: TextStyle(
          fontSize: 21,                               // <-- hint text size
          color: CupertinoColors.systemGrey,         // optional: hint color
        ),
        style: TextStyle(
          fontSize: 21,                               // <-- input text size
          color: _isDarkMode ? CupertinoColors.white : CupertinoColors.black,
        ),
      )
    );
  }

  Widget _myPasswordField(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
      child: CupertinoTextField(
        controller: _passwordController,                      
        padding: EdgeInsets.all(16),
        placeholder: 'Password',
                  // <-- hint text
        placeholderStyle: TextStyle(
          fontSize: 21,                               // <-- hint text size
          color: CupertinoColors.systemGrey,         // optional: hint color
        ),
        style: TextStyle(
          fontSize: 21,      
          color: _isDarkMode ? Colors.white : Colors.black                       // <-- input text size
        ),
        obscureText: _hidePasssword,
        suffix: IconButton(onPressed: handleHidePassword, 
          icon: Icon(getRevealPasswordIcon())),
      )
    );
  }

  IconData getRevealPasswordIcon(){
    return _hidePasssword ? CupertinoIcons.eye_fill
                : CupertinoIcons.eye_slash_fill;
  }

  void handleHidePassword(){
    setState(() {
      _hidePasssword = !_hidePasssword;
    });
  }
  
  handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    debugPrint("email : $email - password : $password");
    _loginViewModel.login(email, password);
    _loginViewModel.getAuthReponse().listen((authResponse){
      navigateToHomePage();
    });
  }

  void navigateToHomePage(){
    Navigator.push(context, 
      CupertinoPageRoute(builder: (context){
        return const MyHomePage(
          title: "",
        );
      })
    );
  }
  
  void demo() {
    _emailController.text = "nghiem@gmail.com";
    _passwordController.text = "123123";
  }
}