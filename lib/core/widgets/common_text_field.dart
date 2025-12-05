import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final String? labelText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isRoundedFull; // Added for Auth styling

  const CommonTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.labelText,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.isRoundedFull = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(isRoundedFull ? 100 : 10);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: AppTextStyles.body1.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: AppTextStyles.body2.copyWith(color: AppColors.textHint),
        prefixIcon: prefixIcon,
        fillColor: isRoundedFull
            ? const Color(0xFFFAFAFA)
            : AppColors.surface, // React Auth uses FAFAFA
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: isRoundedFull ? const Color(0xFFEAEAEA) : AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: isRoundedFull ? const Color(0xFFEAEAEA) : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
