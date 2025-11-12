import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/viewmodels/auth_viewmodel.dart';
import 'package:taskapp/views/screens/loginsignup/login_screen.dart';

import '../../../core/utils/widgets/reuseable_buttons.dart';
import '../../../core/utils/widgets/reuseable_fields.dart';
import '../../../core/utils/widgets/reuseable_image_widget.dart';
import '../../../core/utils/widgets/reuseable_text_buttons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

final TextEditingController usernameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReuseableImageWidget(img: 'loginimg.png', height: 140, width: 280),
            SizedBox(height: 56),
            ReuseableFields(
              controller: usernameController,
              hintText: 'Username',
            ),
            SizedBox(height: 13),
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
                    text: "Register",
                    callback: () async {
                      await authVM.signUp(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        usernameController.text.trim(),
                        context,
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
              text: 'Already have account?',
              clickabletext: 'Sign in',
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
