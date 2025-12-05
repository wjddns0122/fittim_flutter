import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Variables from CSS
  static const double textBase = 16.0; // --text-base
  static const double textLg = 18.0; // --text-lg
  static const double textXl = 20.0; // --text-xl
  static const double text2xl = 24.0; // --text-2xl

  static const FontWeight weightNormal =
      FontWeight.w400; // --font-weight-normal
  static const FontWeight weightMedium =
      FontWeight.w500; // --font-weight-medium

  static TextStyle get _baseStyle => GoogleFonts.inter(
    color: AppColors.textPrimary,
    letterSpacing: -0.02, // Tight tracking often seen in modern UI
  );

  static TextStyle get headline1 =>
      _baseStyle.copyWith(fontSize: text2xl, fontWeight: weightMedium);

  static TextStyle get headline2 =>
      _baseStyle.copyWith(fontSize: textXl, fontWeight: weightMedium);

  static TextStyle get titleMedium =>
      _baseStyle.copyWith(fontSize: textLg, fontWeight: weightMedium);

  static TextStyle get body1 =>
      _baseStyle.copyWith(fontSize: textBase, fontWeight: weightNormal);

  static TextStyle get body2 => _baseStyle.copyWith(
    fontSize: 14.0, // Small text (often .875rem)
    fontWeight: weightNormal,
  );

  static TextStyle get button => _baseStyle.copyWith(
    fontSize: textBase,
    fontWeight: weightMedium,
    color: AppColors.textInverse,
  );

  // Aliases for compatibility
  static TextStyle get logo => headline1.copyWith(
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  ); // Special logo style
  static TextStyle get slogan => body1.copyWith(fontWeight: FontWeight.w300);
  static TextStyle get heroHeading => headline1.copyWith(fontSize: 32);
  static TextStyle get caption =>
      body2.copyWith(color: AppColors.textSecondary);
  static TextStyle get tiny => body2.copyWith(fontSize: 12);
  static TextStyle get subtitle => titleMedium;
  static TextStyle get buttonPrimary => button;
  static TextStyle get input => body1;
  static TextStyle get body => body1;
}
