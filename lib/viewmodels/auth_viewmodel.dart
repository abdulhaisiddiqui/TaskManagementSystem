import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../core/utils/widgets/custom_snackbar.dart';
import '../data/repositories/notificationrepository/notification_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/errors/firebase_error_mapper.dart';
import '../core/utils/widgets/text_widget.dart';
import '../data/repositories/authrepositories/auth_repository.dart';
import '../data/models/user_model.dart';
import '../main.dart';
import '../views/screens/bottomnav/bottomnav_screen.dart';
import '../views/screens/home/home_screen.dart';
import '../views/screens/loginsignup/login_screen.dart';
import '../data/local/local_database_helper.dart';

class AuthViewModel extends ChangeNotifier {
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading (bool value){
    _isLoading = value;
    notifyListeners();
  }

  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  String? _error;
  String? get error => _error;

  UserModel? _user;
  UserModel? get user => _user;

  Future<void> signUp(String email, String password, String displayName,BuildContext context) async {
    _isLoading = true;
    _error = null;


    try {
      _user = await _authRepository.signUp(displayName: displayName, email: email, password: password, context: context);
      // Save basic user info locally for offline login/session (no passwords)
      if (_user != null) {
        try {
          await LocalDatabaseHelper().saveUserOffline(
            uid: _user!.uid,
            email: _user!.email,
            displayName: _user!.displayName,
            photoURL: _user!.photoURL,
            createdAt: _user!.createdAt,
          );
        } catch (_) {}
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      final errorMessage = FirebaseErrorMapper().handleAuthError(e.code);
      CustomSnackBar.error(message: errorMessage, context: context);
    } catch (e) {
      CustomSnackBar.error(message: "Something went wrong: $e", context: context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;  // Direct setter use karo, setter trigger karega notifyListeners
    _error = null;

    try {
      final user = await _authRepository.login(email: email, password: password, context: context);

      if (user != null && user.emailVerified) {
        final userDoc = await _authRepository.getUserDoc(user.uid);

        if (!userDoc.exists) {
          final userModel = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? '',
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
            },
          );
          await _authRepository.createUserDoc(user.uid, userModel);

          await LocalDatabaseHelper().saveUserOffline(
            uid: userModel.uid,
            email: userModel.email,
            displayName: userModel.displayName,
            photoURL: userModel.photoURL,
            createdAt: userModel.createdAt,
          );
        } else {
          final data = userDoc.data()!;
          final savedUser = UserModel.fromMap(user.uid, data);
          await LocalDatabaseHelper().saveUserOffline(
            uid: savedUser.uid,
            email: savedUser.email,
            displayName: savedUser.displayName,
            photoURL: savedUser.photoURL,
            createdAt: savedUser.createdAt,
          );
        }

        CustomSnackBar.success(message: "Login successful!", context: context);

        // Navigation ke PEHLE loading false mat karo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomNavScreen()),
        );

      } else {
        CustomSnackBar.warning(message: "Please verify your email first.", context: context);
        await _authRepository.logout(context: context);
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = FirebaseErrorMapper().handleAuthError(e.code);
      CustomSnackBar.error(message: errorMessage, context: context);
    } catch (e) {
      CustomSnackBar.error(message: "Something went wrong: $e", context: context);
    } finally {
      isLoading = false;
    }
  }
  Future<void> logout(BuildContext context) async {
    setLoading(true);

    try {
      await _authRepository.logout(context: context);

      CustomSnackBar.success(message: "Logged out successfully", context: context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      CustomSnackBar.error(message: "Logout failed: $e", context: context);
    } finally {
      setLoading(false);
    }
  }

  /// Sign in with Google (MVVM). Calls repository and navigates on success.
  Future<void> signInWithGoogle(BuildContext context) async {
    setLoading(true);
    try {
      final user = await _authRepository.signInWithGoogle(context: context);
      if (user != null) {
        // After sign-in, navigate to app main screen
        CustomSnackBar.success(message: 'Signed in with Google', context: context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      CustomSnackBar.error(message: 'Google sign-in failed: $e', context: context);
    } finally {
      setLoading(false);
    }
  }
  /// Upload profile image via repository and update local user model.
  Future<String?> uploadProfileImage(File file, BuildContext context) async {
    setLoading(true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        CustomSnackBar.warning(message: 'User not logged in', context: context);
        return null;
      }

      final url = await _authRepository.uploadAndSetProfilePhoto(file: file, uid: uid, context: context);

      if (url != null && _user != null) {
        _user = _user!.copyWith(photoURL: url);
        notifyListeners();
      }

      return url;
    } catch (e) {
      CustomSnackBar.error(message: 'Upload failed: $e', context: context);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Debug helper: attempt a small write to Storage to verify bucket/rules.
  Future<bool> debugStorageWriteTest(BuildContext context) async {
    setLoading(true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        CustomSnackBar.warning(message: 'User not logged in', context: context);
        return false;
      }

      final path = 'users/$uid/debug_test_${DateTime.now().millisecondsSinceEpoch}.bin';
      final ref = FirebaseStorage.instance.ref().child(path);

      final Uint8List data = Uint8List.fromList([0, 1, 2, 3]);

      final taskSnapshot = await ref.putData(data, SettableMetadata(contentType: 'application/octet-stream'));

      // Try to get download URL to confirm object exists
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      debugPrint('Debug upload succeeded: $downloadUrl');
      CustomSnackBar.success(message: 'Debug upload succeeded', context: context);
      return true;
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException during debug upload: code=${e.code} message=${e.message}');
      CustomSnackBar.error(message: 'Debug upload failed: ${e.message ?? e.code}', context: context);
      return false;
    } catch (e) {
      debugPrint('Unexpected error during debug upload: $e');
      CustomSnackBar.error(message: 'Debug upload failed: $e', context: context);
      return false;
    } finally {
      setLoading(false);
    }
  }
}
