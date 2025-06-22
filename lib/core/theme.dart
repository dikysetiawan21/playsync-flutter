import 'package:flutter/material.dart';

class AppColors {
  static const Color dark = Color(0xFF170909);
  static const Color purple = Color(0xFF6D2177);
  static const Color pink = Color(0xFFF6008C);
  static const Color lightPink = Color(0xFFF78DA7);
  static const Color white = Colors.white;
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.purple,
  scaffoldBackgroundColor: AppColors.white,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColors.purple,
    secondary: AppColors.pink,
    surface: AppColors.white,
  ),
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(color: AppColors.dark),
  ),
);
