import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFA85485);
  static const Color secondary = Color(0xFFEC7FA9);
  static const Color background = Color(0xFFFFEDFA);
  static const Color btnBg = Color(0xFFFFB8E0);
  static const Color text = Color(0xFF333333);
  static const Color lightText = Color(0xFF777777);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class Styles {
  static const TextStyle smallTextW500 =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
  static const TextStyle smallTextW700 =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700);
  static const TextStyle smallTextW800 =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800);
  static const TextStyle mediumTextW500 =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);
  static const TextStyle mediumTextW700 =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700);
  static const TextStyle mediumTextW800 =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800);
  static const TextStyle bigTextW500 =
      TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500);
  static const TextStyle bigTextW700 =
      TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700);
  static const TextStyle bigTextW800 =
      TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w800);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: AppColors.primary),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.text,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
