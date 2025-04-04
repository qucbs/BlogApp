import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: AppColors.primary,
      width: 3,
    ),
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          width: 3,
        ),
      ),
      focusedBorder: _border,
    ),
  );
}
