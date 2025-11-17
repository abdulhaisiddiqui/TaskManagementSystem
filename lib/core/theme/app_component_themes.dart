import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_theme_constants.dart';

class AppComponentThemes {
  // Helper method for creating borders
  static OutlineInputBorder _border([Color color = AppColors.gray400]) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: AppThemeConstants.borderWidth,
      ),
      borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
    );
  }

  // Elevated Button Theme
  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
        ),
      ),
    );
  }

  // Card Theme
  static CardTheme get lightCardTheme {
    return CardTheme(
      color: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
      ),
    );
  }

  static CardTheme get darkCardTheme {
    return CardTheme(
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
      ),
    );
  }

  // Input Decoration Theme
  static InputDecorationTheme get lightInputDecorationTheme {
    return InputDecorationTheme(
      enabledBorder: _border(),
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: _border(),
      focusedBorder: _border(AppColors.primary),
      errorBorder: _border(AppColors.error),
      disabledBorder: _border(AppColors.gray600),
      focusedErrorBorder: _border(AppColors.error),
      hintStyle: const TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryLight,
      ),
      iconColor: AppColors.textSecondaryLight,
      prefixIconColor: AppColors.textSecondaryLight,
      suffixIconColor: AppColors.textSecondaryLight,
    );
  }

  static InputDecorationTheme get darkInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
      ),
    );
  }

  // AppBar Theme
  static AppBarTheme get appBarTheme {
    return const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      titleTextStyle: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.onPrimary,
      ),
    );
  }

  // FloatingActionButton Theme
  static FloatingActionButtonThemeData get floatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
    );
  }

  // Icon Theme
  static IconThemeData get lightIconTheme {
    return const IconThemeData(color: AppColors.onBackgroundLight);
  }

  static IconThemeData get darkIconTheme {
    return const IconThemeData(color: AppColors.onBackgroundDark);
  }

  // Divider Theme
  static DividerThemeData get dividerTheme {
    return const DividerThemeData(color: AppColors.gray600);
  }

  // Switch Theme
  static SwitchThemeData get switchTheme {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.primary),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.gray600),
    );
  }

  // Checkbox Theme
  static CheckboxThemeData get checkboxTheme {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primary),
    );
  }

  // Radio Theme
  static RadioThemeData get radioTheme {
    return RadioThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primary),
    );
  }

  // Progress Indicator Theme
  static ProgressIndicatorThemeData get progressIndicatorTheme {
    return const ProgressIndicatorThemeData(color: AppColors.primary);
  }

  // Slider Theme
  static SliderThemeData get sliderTheme {
    return const SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.gray600,
      thumbColor: AppColors.primary,
    );
  }
}
