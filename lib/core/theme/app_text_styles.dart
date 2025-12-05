import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Base font
  static TextStyle get _baseStyle => GoogleFonts.inter();

  // Logo (42px, w200, tracking 0.2em)
  static TextStyle get logo => _baseStyle.copyWith(
    fontSize: 42,
    fontWeight: FontWeight.w200,
    letterSpacing: 8.4, // 0.2em * 42
    color: AppColors.textPrimary,
  );

  // Hero Heading (28px, w300, leading 1.3)
  static TextStyle get heroHeading => _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Title Medium (22px, w600)
  static TextStyle get titleMedium => _baseStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Slogan (24px, w300, leading 1.4)
  static TextStyle get slogan => _baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Temperature (20px, w300)
  static TextStyle get temperature => _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );

  // Body / Button (15px, w400/w300)
  static TextStyle get body => _baseStyle.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get buttonPrimary => _baseStyle.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.buttonText,
  );

  // Input Text (15px, w300)
  static TextStyle get input => _baseStyle.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );

  // Caption / Micro text (13px, w300, tracking 0.1em)
  static TextStyle get caption => _baseStyle.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.3, // 0.1em * 13
    color: AppColors.textPrimary,
  );

  // Subtitle / Divider text (12px, w300)
  static TextStyle get subtitle => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  // Tiny (11px, w300)
  static TextStyle get tiny => _baseStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}
