import 'package:flutter/material.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.card,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: AppColors.text),
        titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: AppColors.text),
        bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: AppColors.textSecondary),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primary,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
    );
  }
}
