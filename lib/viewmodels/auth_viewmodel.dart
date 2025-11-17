import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  }

  String? _error;
  String? get error => _error;

  UserModel? _user;
  UserModel? get user => _user;

  Future<void> signUp(String email, String password, String displayName,BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepository.signUp(displayName: displayName, email: email, password: password, context: context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
      // Login success ke baad
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
            (route) => false,
      );
    }on FirebaseAuthException catch (e) {
      final errorMessage = FirebaseErrorMapper().handleAuthError(e.code);
      _showSnackBar(context, errorMessage);
    } catch (e) {
      _showSnackBar(context, "Something went wrong: $e");
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
    setLoading(true);
    _error = null;

    try {
      final user = await _authRepository.login(email: email, password: password,context: context);

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
        }

        _showSnackBar(context, "Login successful!");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
      } else {
        _showSnackBar(context, "Please verify your email first.");

        await _authRepository.logout(context: context);
      }
      // Login success ke baad
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = FirebaseErrorMapper().handleAuthError(e.code);
          _showSnackBar(context, errorMessage);
    } catch (e) {
      _showSnackBar(context, "Something went wrong: $e");
    } finally {
      setLoading(false);
    }
  }
  Future<void> logout(BuildContext context) async {
    setLoading(true);

    try {
      await _authRepository.logout(context: context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged out successfully")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    } finally {
      setLoading(false);
    }
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
