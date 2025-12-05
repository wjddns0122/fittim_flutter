import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('FITTIM', style: AppTextStyles.logo.copyWith(fontSize: 48)),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: AppColors.textPrimary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
