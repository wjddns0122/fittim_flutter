import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.textPrimary,
    barBackgroundColor: AppColors.backgroundPrimary,
    scaffoldBackgroundColor: AppColors.backgroundPrimary,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.textPrimary,
      textStyle: AppTextStyles.body,
      navTitleTextStyle: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w600,
      ),
      tabLabelTextStyle: AppTextStyles.tiny.copyWith(fontSize: 10),
    ),
  );

  static ThemeData get materialTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.textPrimary,
      surface: AppColors.backgroundPrimary,
      onSurface: AppColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundPrimary,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
    ),
  );
}
