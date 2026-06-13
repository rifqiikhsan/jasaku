import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF163360);
  static const Color accent = Color(0xFFF6AD23);
  static const Color background = Color(0xFFF0F2F7);
  static const Color surface = Colors.white;
  static const Color textHint = Color(0xFFAAAEB6);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: surface,
    ),
  );
}
