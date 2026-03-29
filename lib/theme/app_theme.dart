import 'package:flutter/material.dart';

class AppTheme {
  static const Color cemigBlue = Color(0xFF003A8F);
  static const Color cemigYellow = Color(0xFFFFD100);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: cemigBlue,
      primary: cemigBlue,
      secondary: cemigYellow,
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F6F8),
    appBarTheme: const AppBarTheme(
      backgroundColor: cemigBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 2,
    ),
    cardTheme: CardTheme(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: cemigBlue, width: 2),
      ),
    ),
  );
}