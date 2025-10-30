import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
    );
  }

  static Color getConfidenceColor(double confidence) {
    if (confidence >= 0.6) {
      return Colors.green.shade600;
    } else if (confidence >= 0.3) {
      return Colors.amber.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  static String getConfidenceLabel(double confidence) {
    if (confidence >= 0.6) {
      return 'High';
    } else if (confidence >= 0.3) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }
}
