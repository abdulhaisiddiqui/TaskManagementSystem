import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/utils/constants/app_constants.dart';
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

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120),
            ReuseableImageWidget(img: 'loginimg.png', height: 180, width: 350),
            SizedBox(height: 30),
            ReuseableFields(
              controller: emailController,
              hintText: 'Email',

            ),
            SizedBox(height: 30),
            ReuseableFields(

              controller: passwordController,
              hintText: 'Password',
            ),
            SizedBox(height: 33),
            Consumer<AuthViewModel>(builder: (context,value,child){
              return value.isLoading
                  ? CircularProgressIndicator()
                  : ReuseableButtons(
                text: "Log in",
                callback: () async {
                  await value.login(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    context: context,
                  );

                  if (value.error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(value.error!)));
                  }
                },
              );
            }),
            SizedBox(height: 30),

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
