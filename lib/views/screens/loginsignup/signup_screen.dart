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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ReuseableImageWidget(img: 'loginimg.png', height: 140, width: 280),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Sign up to Taskapp',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Set task today by signing up \nfor our task app!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(height: 30),
            ReuseableFields(
              controller: usernameController,
              hintText: 'Username',
            ),
            SizedBox(height: 30),
            ReuseableFields(controller: emailController, hintText: 'Email'),
            SizedBox(height: 30),
            ReuseableFields(
              controller: passwordController,
              hintText: 'Password',
            ),
            SizedBox(height: 30),

            Consumer<AuthViewModel>(
              builder: (context, authVm, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: authVm.isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: const AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Signing up...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : ReuseableButtons(
                          text: "Register",
                          callback: () async {
                            await authVm.signUp(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              usernameController.text.trim(),
                              context,
                            );
                            if (authVm.error != null) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(authVm.error!)));
                            }
                          },
                        ),
                );
              },
            ),
            SizedBox(height: 30),
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
