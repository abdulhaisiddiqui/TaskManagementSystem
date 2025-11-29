import 'package:flutter/material.dart';

import 'app_color.dart';

class AppColorSchemes {
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.gray500,
    onSecondary: AppColors.onBackgroundLight,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.onSurfaceLight,
    error: AppColors.error,
    onError: AppColors.onError,
    outline: AppColors.gray600,
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.gray500,
    onSecondary: AppColors.onBackgroundDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
    error: AppColors.error,
    onError: AppColors.onError,
    outline: AppColors.gray600,
  );
}
