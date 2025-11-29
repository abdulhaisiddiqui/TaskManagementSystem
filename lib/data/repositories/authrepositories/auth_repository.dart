import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/utils/widgets/custom_snackbar.dart';
import '../../../core/errors/firebase_error_mapper.dart';
import '../../models/user_model.dart';
import '../../../core/errors/firebase_error_mapper.dart';
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


  /// Sign up: create Firebase Auth user, set displayName, create Firestore user doc,
  /// send verification email and sign out so user verifies before logging in.
  Future<UserModel?> signUp({
    required String displayName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      // Update Firebase Auth profile
      await user.updateDisplayName(displayName);

      // Prepare user model and save to Firestore
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        notificationSettings: {
          'enabled': true,
          'dailySummaryTime': '08:00',
          'defaultReminderTime': 60,
        },
        stats: {
          'totalTasks': 0,
          'completedTasks': 0,
          'pendingTasks': 0,
          'currentStreak': 0,
          'longestStreak': 0,
          'lastActiveDate': null,
          'totalTasksCompleted': 0,
        },
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      // Send verification email and sign out
      await user.sendEmailVerification();
      CustomSnackBar.info(message: 'Verification email sent! Please verify then log in.', context: context);
      await _auth.signOut();

      return userModel;
    } on FirebaseAuthException catch (e) {
      final msg = FirebaseErrorMapper().handleAuthError(e.code);
      CustomSnackBar.error(message: msg, context: context);
    } catch (e) {
      CustomSnackBar.error(message: 'Sign up failed: $e', context: context);
    }

    return null;
  }



  /// Sign in with Google and ensure a Firestore user doc exists.
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    try {
      final googleSignIn = GoogleSignIn.standard();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // user cancelled

      final googleAuth = await googleUser.authentication;

      // `googleAuth` shape can vary across package versions; use dynamic accessors
      final dynamic dynAuth = googleAuth;
      final accessToken = dynAuth.accessToken as String?;
      final idToken = dynAuth.idToken as String?;

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      // Ensure Firestore user doc exists
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          photoURL: user.photoURL,
          createdAt: DateTime.now(),
          notificationSettings: {
            'enabled': true,
            'dailySummaryTime': '08:00',
            'defaultReminderTime': 60,
          },
          stats: {
            'totalTasks': 0,
            'completedTasks': 0,
            'pendingTasks': 0,
            'currentStreak': 0,
            'longestStreak': 0,
            'lastActiveDate': null,
            'totalTasksCompleted': 0,
          },
        );

        await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      }

      return user;
    } on FirebaseAuthException catch (e) {
      final msg = FirebaseErrorMapper().handleAuthError(e.code);
      CustomSnackBar.error(message: msg, context: context);
    } catch (e) {
      CustomSnackBar.error(message: 'Google sign-in failed: $e', context: context);
    }

    return null;
  }

  /// Uploads [file] to Firebase Storage at `users/{uid}/profile.jpg`, updates
  /// the Firebase Auth user's `photoURL` and merges the `photoURL` into
  /// Firestore `users/{uid}` document. Returns the download URL on success.
  Future<String?> uploadAndSetProfilePhoto({
    required File file,
    required String uid,
    required BuildContext context,
    String? storagePath,
  }) async {
    if (!await file.exists()) {
      CustomSnackBar.error(message: "Selected file does not exist", context: context);
      return null;
    }

    try {
      final filename = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = storagePath ?? 'users/$uid/$filename';
      final storageRef = FirebaseStorage.instance.ref().child(path);

      debugPrint('Uploading profile photo to Storage path: $path');

      final taskSnapshot = await storageRef.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Ensure the uploaded object exists and get URL
      final downloadURL = await taskSnapshot.ref.getDownloadURL();

      debugPrint('Upload succeeded. downloadURL: $downloadURL');

      // Update Firebase Auth profile if current user matches
      final currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == uid) {
        try {
          await currentUser.updatePhotoURL(downloadURL);
        } catch (e) {
          debugPrint('Warning: failed to update Auth photoURL: $e');
        }
      }

      // Merge photoURL into Firestore user doc
      await _firestore.collection('users').doc(uid).set({'photoURL': downloadURL}, SetOptions(merge: true));

      CustomSnackBar.success(message: 'Profile photo updated', context: context);
      return downloadURL;
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException during upload: code=${e.code} message=${e.message}');
      CustomSnackBar.error(message: 'Upload failed: ${e.message ?? e.code}', context: context);
    } catch (e) {
      debugPrint('Unexpected error during upload: $e');
      CustomSnackBar.error(message: 'Upload failed: $e', context: context);
    }

    return null;
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
    return null;
  }


}
