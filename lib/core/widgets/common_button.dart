import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final Color? backgroundColor;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56, // Standard touch target
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          disabledBackgroundColor: AppColors.surface, // Gray 100 for disabled
          disabledForegroundColor:
              AppColors.textHint, // Gray 400 for disabled text
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Aligned with input fields
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(
            color: isDisabled ? AppColors.textHint : AppColors.textInverse,
          ),
        ),
      ),
    );
  }
}
