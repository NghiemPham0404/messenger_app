import 'package:chatting_app/ui/view_models/signup_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpViewModel>(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Sign up your account")),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getDefaultAvatar(context, viewModel),
                        const SizedBox(height: 20),
                        _getEmailField(context, viewModel),
                        const SizedBox(height: 12),
                        _getNameField(context, viewModel),
                        const SizedBox(height: 12),
                        _getPasswordField(context, viewModel),
                        const SizedBox(height: 20),
                        _getVerifyPasswordField(context, viewModel),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            onPressed:
                                viewModel.isLoading
                                    ? null
                                    : () => _submit(context, viewModel),
                            color: Theme.of(context).colorScheme.onSurface,
                            child:
                                viewModel.isLoading
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      "Register",
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getDefaultAvatar(BuildContext context, SignUpViewModel viewModel) {
    if (nameController.text.isEmpty) {
      return SvgPicture.asset(
        "assets/images/user-svgrepo-com.svg",
        width: 64,
        height: 64,
      );
    } else {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(
          "https://api.dicebear.com/9.x/initials/png?seed=${nameController.text}&backgroundType=gradientLinear",
        ),
        backgroundColor: Colors.grey[800],
      );
    }
  }

  Widget _getEmailField(BuildContext context, SignUpViewModel viewModel) {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email',
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

  Widget _getNameField(BuildContext context, SignUpViewModel viewModel) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: 'Name',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        }

        // Optional: Add length or format constraints
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }

        return null; // valid
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _getPasswordField(BuildContext context, SignUpViewModel viewModel) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: () => viewModel.avatarGenerate(nameController.text),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _getVerifyPasswordField(
    BuildContext context,
    SignUpViewModel viewModel,
  ) {
    return TextFormField(
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Verify Password',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator:
          (value) =>
              (value != passwordController.text &&
                      (value?.length ?? 0) >= passwordController.text.length)
                  ? "The passwords do not match"
                  : null,
    );
  }

  void _submit(BuildContext context, SignUpViewModel viewModel) {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final password = passwordController.text;

    if (_formKey.currentState!.validate()) {
      viewModel.register(email, name, password);
    }
  }
}
