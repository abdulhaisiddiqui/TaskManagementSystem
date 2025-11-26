import 'package:flutter/material.dart';
import 'package:taskapp/core/theme/app_color.dart';
import '../widgets/text_widget.dart';

class CustomSnackBar {
  /// Show a customizable snackbar with message, context, and background color.
  static void show({
    required String message,
    required BuildContext context,
    Color backgroundColor = const Color(0xFF828282),
    Duration duration = const Duration(seconds: 3),
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    double borderRadius = 15,
    double elevation = 0,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
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
        backgroundColor: backgroundColor.withOpacity(0.9),
        behavior: behavior,
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
        duration: duration,
      ),
    );
  }

  /// Success snackbar (green background)
  static void success({
    required String message,
    required BuildContext context,
  }) {
    show(
      message: message,
      context: context,
      backgroundColor: const Color(0xFF4CAF50),
    );
  }

  /// Error snackbar (red background)
  static void error({
    required String message,
    required BuildContext context,
  }) {
    show(
      message: message,
      context: context,
      backgroundColor: const Color(0xFFFF5252),
    );
  }

  /// Warning snackbar (orange background)
  static void warning({
    required String message,
    required BuildContext context,
  }) {
    show(
      message: message,
      context: context,
      backgroundColor: const Color(0xFFFFA726),
    );
  }

  /// Info snackbar (blue background)
  static void info({
    required String message,
    required BuildContext context,
  }) {
    show(
      message: message,
      context: context,
      backgroundColor: const Color(0xFF42A5F5),
    );
  }

  // for app theme
  static void appTheme({
    required String message,
    required BuildContext context,
  }) {
    show(
      message: message,
      context: context,
      backgroundColor: AppColors.primary,
    );
  }
}
