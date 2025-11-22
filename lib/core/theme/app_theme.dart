import 'package:flutter/material.dart';

import 'app_color.dart' show AppColors;
import 'app_color_schemes.dart';
import 'app_component_themes.dart';
import 'app_text_themes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTextThemes.lightTextTheme,
      iconTheme: AppComponentThemes.lightIconTheme,
      dividerTheme: AppComponentThemes.dividerTheme,
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme,
      // cardTheme: AppComponentThemes.lightCardThemeData,
      inputDecorationTheme: AppComponentThemes.lightInputDecorationTheme,
      appBarTheme: AppComponentThemes.appBarTheme,
      floatingActionButtonTheme: AppComponentThemes.floatingActionButtonTheme,
      switchTheme: AppComponentThemes.switchTheme,
      checkboxTheme: AppComponentThemes.checkboxTheme,
      radioTheme: AppComponentThemes.radioTheme,
      progressIndicatorTheme: AppComponentThemes.progressIndicatorTheme,
      sliderTheme: AppComponentThemes.sliderTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: AppColorSchemes.darkColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppTextThemes.darkTextTheme,
      iconTheme: AppComponentThemes.darkIconTheme,
      dividerTheme: AppComponentThemes.dividerTheme,
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme,
      // cardTheme: AppComponentThemes.darkCardTheme,
      inputDecorationTheme: AppComponentThemes.darkInputDecorationTheme,
      appBarTheme: AppComponentThemes.appBarTheme,
      floatingActionButtonTheme: AppComponentThemes.floatingActionButtonTheme,
      switchTheme: AppComponentThemes.switchTheme,
      checkboxTheme: AppComponentThemes.checkboxTheme,
      radioTheme: AppComponentThemes.radioTheme,
      progressIndicatorTheme: AppComponentThemes.progressIndicatorTheme,
      sliderTheme: AppComponentThemes.sliderTheme,
    );
  }
}
