import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskapp/core/utils/constants/app_constants.dart';
import 'package:taskapp/views/screens/loginsignup/login_screen.dart';

import '../../../core/utils/widgets/reuseable_image_widget.dart';
import '../../../core/utils/widgets/text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    });

  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReuseableImageWidget(img: 'splash2.png'),
            TextWidget(
              text: 'Manage your task, \nquickly.',
              txtStyle: TextStyle(
                color: AppConstants.textColor.withOpacity(0.6),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
