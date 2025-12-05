import 'package:flutter/cupertino.dart';
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
}
