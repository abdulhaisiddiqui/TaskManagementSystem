import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/utils/widgets/reuseable_buttons.dart';
import 'package:taskapp/core/utils/widgets/reuseable_fields.dart';
import 'package:taskapp/core/utils/widgets/reuseable_image_widget.dart';
import 'package:taskapp/core/utils/widgets/reuseable_text_buttons.dart';
import 'package:taskapp/data/repositories/authrepositories/auth_repository.dart';
import 'package:taskapp/views/screens/loginsignup/signup_screen.dart';

import '../../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final _authRepo = AuthRepository();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReuseableImageWidget(img: 'loginimg.png', height: 140, width: 280),
            SizedBox(height: 56),
            ReuseableFields(controller: emailController, hintText: 'Email'),
            SizedBox(height: 13),
            ReuseableFields(
              controller: passwordController,
              hintText: 'Password',
            ),
            SizedBox(height: 33),
            authVM.isLoading
                ? CircularProgressIndicator()
                : ReuseableButtons(
                    text: "Log in",
                    callback: () async {
                      await authVM.login(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        context: context,
                      );

                      if (authVM.error != null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(authVM.error!)));
                      }
                    },
                  ),
            SizedBox(height: 5),
            ReuseableTextButtons(
              text: 'Dont have an account?',
              clickabletext: 'Create account',
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
