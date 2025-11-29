import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_theme_constants.dart';

class AppTextThemes {
  static TextTheme get lightTextTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundLight,
      ),
      displayMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundLight,
      ),
      displaySmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundLight,
      ),
      headlineLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackgroundLight,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackgroundLight,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackgroundLight,
      ),
      titleLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackgroundLight,
      ),
      titleMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackgroundLight,
      ),
      titleSmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackgroundLight,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundLight,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundLight,
      ),
      bodySmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundLight,
      ),
      labelLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryLight,
      ),
      labelMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryLight,
      ),
      labelSmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryLight,
      ),
    );
  }

  static TextTheme get darkTextTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundDark,
      ),
      displayMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundDark,
      ),
      displaySmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundDark,
      ),
      headlineLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackgroundDark,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackgroundDark,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackgroundDark,
      ),
      titleLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackgroundDark,
      ),
      titleMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackgroundDark,
      ),
      titleSmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackgroundDark,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundDark,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundDark,
      ),
      bodySmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackgroundDark,
      ),
      labelLarge: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryDark,
      ),
      labelMedium: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryDark,
      ),
      labelSmall: TextStyle(
        fontFamily: AppThemeConstants.fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryDark,
      ),
    );
  }
}
