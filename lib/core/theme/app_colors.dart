import 'package:flutter/material.dart';

class AppColors {
  // Extracted from src/index.css and component HEX codes

  // --primary / Text: #1A1A1A
  static const Color primary = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFF1A1A1A);

  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F7F7); // General Surface
  static const Color inputBackground = Color(0xFFFAFAFA); // Auth Input

  // Borders
  static const Color border = Color(0xFFF0F0F0); // General Border
  static const Color inputBorder = Color(
    0xFFEAEAEA,
  ); // Auth Input Border, Divider

  // Text
  static const Color textSecondary = Color(0xFF9C9C9C); // Inactive Tab, Hints
  static const Color textHint = Color(0xFF9C9C9C);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Brand / Accents
  static const Color brandBlue = Color(0xFF74A8FF); // FAB, Tags
  static const Color kakaoYellow = Color(0xFFFEE500); // Social Login
  static const Color error = Color(0xFFD4183D); // Error
}
