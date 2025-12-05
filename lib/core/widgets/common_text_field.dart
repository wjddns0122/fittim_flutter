import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final String? labelText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isRoundedFull;

  const CommonTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.labelText,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.isRoundedFull =
        false, // Defaults to false (Wardrobe style 10px), set true for Auth
  });

  @override
  Widget build(BuildContext context) {
    // React Login uses 'rounded-full' -> StadiumBorder (effectively huge radius)
    final borderRadius = BorderRadius.circular(isRoundedFull ? 100 : 10);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      // React: text-[15px] font-thin 300
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
        prefixIcon: prefixIcon,
        // React: bg-[#FAFAFA]
        fillColor: isRoundedFull
            ? AppColors.inputBackground
            : AppColors.surface,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ), // py-4 (1rem=16px)
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: isRoundedFull ? AppColors.inputBorder : AppColors.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: isRoundedFull ? AppColors.inputBorder : AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
