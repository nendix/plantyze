import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color _primaryLight = Color(0xFFa7c4a0);
  static const Color _primaryDark = Color(0xFF9ec49a);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryLight,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryDark,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Poppins',
    );
  }
}
