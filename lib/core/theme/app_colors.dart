import 'package:flutter/material.dart';

class AppColors {
  // Extracted from src/index.css
  static const Color black = Color(0xFF000000); // --color-black
  static const Color white = Color(0xFFFFFFFF); // --color-white
  static const Color gray100 = Color(0xFFF3F4F6); // --color-gray-100 (approx)
  static const Color red500 = Color(0xFFEF4444); // --color-red-500 (approx)
  static const Color red600 = Color(0xFFDC2626); // --color-red-600 (approx)

  // Semantic Aliases
  static const Color primary = black;
  static const Color background = white;
  static const Color surface = gray100;
  static const Color error = red500;

  static const Color textPrimary = black;
  static const Color textInverse = white;
  static const Color textHint = Color(
    0xFF9CA3AF,
  ); // Gray 400 (Standard fallback)
  static const Color textSecondary = Color(
    0xFF4B5563,
  ); // Gray 600 (Standard fallback)

  static const Color border = Color(0xFFE5E7EB); // Gray 200 (Standard fallback)

  // Legacy/Custom Mappings for existing code
  static const Color backgroundPrimary = background;
  static const Color backgroundSecondary = surface;
  static const Color buttonPrimary = primary;
  static const Color buttonText = textInverse;

  // Kakao (External)
  static const Color kakaoYellow = Color(0xFFFEE500);
  static const Color kakaoText = Color(0xFF000000);

  static const Color destructive = red600;
}
