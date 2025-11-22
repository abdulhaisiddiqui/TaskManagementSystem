import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/core/utils/widgets/text_widget.dart';
import 'package:taskapp/viewmodels/auth_viewmodel.dart';
import 'package:taskapp/views/screens/home/home_screen.dart';
import 'package:taskapp/views/screens/loginsignup/login_screen.dart';
import '../../../core/errors/firebase_error_mapper.dart';
import '../../../core/validators.dart';
import '../../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<UserModel?> signUp(String email, String password, String displayName) async {
  //   try {
  //     UserCredential credential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     User? user = credential.user;
  //
  //     if (user != null) {
  //       await user.sendEmailVerification();
  //
  //       UserModel userModel = UserModel(
  //         uid: user.uid,
  //         email: email,
  //         displayName: displayName,
  //         createdAt: DateTime.now(),
  //         notificationSettings: {
  //           'enabled': true,
  //           'dailySummaryTime': '08:00',
  //           'defaultReminderTime': 60,
  //         },
  //         stats: {
  //           'totalTasks': 0,
  //           'completedTasks': 0,
  //           'pendingTasks': 0,
  //         },
  //       );
  //
  //       await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
  //
  //       await user.updateDisplayName(displayName);
  //
  //       return userModel;
  //     }
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     throw Exception(FirebaseErrorMapper().handleAuthError(e.code));
  //   }
  // }

  // Future<UserModel?> signUp({
  //   required String displayname,
  //   required String email,
  //   required String password,
  //   required BuildContext context,
  // }) async {
  //   final passwordError = Validators.validatePassword(
  //     displayname,
  //     email,
  //     password,
  //   );
  //
  //   if (passwordError != null) {
  //     _showSnackBar(context, passwordError);
  //     return null;
  //   }
  //
  //   try {
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //
  //     User? user = userCredential.user;
  //
  //     if (user != null) {
  //       await user.sendEmailVerification();
  //
  //       _showSnackBar(
  //         context,
  //         "Verification email sent! Please verify your email before continuing.",
  //       );
  //
  //       return null;
  //
  //     }else{
  //       UserModel userModel = UserModel(
  //         uid: userCredential.user!.uid,
  //         email: email ?? '',
  //         displayName: displayname ?? '',
  //         createdAt: DateTime.now(),
  //         notificationSettings: {
  //           'enabled': true,
  //           'dailySummaryTime': '08:00',
  //           'defaultReminderTime': 60,
  //         },
  //         stats: {'totalTasks': 0, 'completedTasks': 0, 'pendingTasks': 0},
  //       );
  //       await _firestore
  //           .collection("users")
  //           .doc(userCredential.user!.uid)
  //           .set(userModel.toMap());
  //
  //       _showSnackBar(context, "Signup successful!");
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //       );
  //       await user!.reload();
  //
  //       print("✅ User Created Successfully: ${user.email}");
  //
  //       return userModel;
  //     }
  //
  //     // Navigator.pop(context); // or navigate to Dashboard/HomeScreen
  //   } on FirebaseAuthException catch (e) {
  //     final errorMessage = FirebaseErrorMapper().handleAuthError(e.code);
  //     _showSnackBar(context, errorMessage);
  //   }
  //   return null;
  // }


  Future<UserModel?> signUp({
    required String displayName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();

        _showSnackBar(context,
            "Verification email sent! Please verify your email, then log in.");

        await _auth.signOut();
      }

  }

  Future<User?> login({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    UserCredential credential =
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    return credential.user;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> createUserDoc(String uid, UserModel userModel) async {
    await _firestore.collection('users').doc(uid).set(userModel.toMap());
  }


  Future<UserModel?> logout({required BuildContext context}) async {

      await _auth.signOut();


  }


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(
          text: message,
          txtStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF828282).withOpacity(0.9), // Fixed color format
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // top, bottom, left, right = 24
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // optional for softer corners
        ),
        elevation: 0, // removes the blur/shadow effect
      ),
    );
  }

}
