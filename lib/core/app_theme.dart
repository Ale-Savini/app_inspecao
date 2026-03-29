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
    ),
  );
}
