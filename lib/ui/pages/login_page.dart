import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_button.dart';
import '../../core/widgets/common_text_field.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              // Logo Section (Expanded to center vertically)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'FITTIM',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 4.0, // tracking-[0.2em] approx
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '남들 말고,\n진짜 나를 입는 시간 10초.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        height: 1.4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 64), // mb-16 approx
                    const Text(
                      'FITTIM, Fit ME.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.3, // tracking-[0.1em]
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),

              // Login Section
              Column(
                children: [
                  CommonTextField(
                    controller: controller.emailController,
                    hintText: '이메일 주소',
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    isRoundedFull: true,
                  ),
                  const SizedBox(height: 12),
                  // Adding Password field as our Auth flow requires it, keeping style consistent
                  Obx(
                    () => CommonTextField(
                      controller: controller.passwordController,
                      hintText: '비밀번호',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      obscureText: !controller.isPasswordVisible.value,
                      isRoundedFull: true,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Obx(
                    () => CommonButton(
                      text: '시작하기',
                      onPressed: controller.login,
                      isLoading: controller.isLoading.value,
                      isRoundedFull: true,
                      backgroundColor: AppColors.primary,
                    ),
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFEAEAEA)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '또는',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFEAEAEA)),
                        ),
                      ],
                    ),
                  ),

                  // Social Login Placeholders (Using CommonButton with custom colors)
                  CommonButton(
                    text:
                        '회원가입 하기', // Using this slot for Register instead of Social for now logic-wise, but titled "Start with Email" or similar
                    onPressed: () => Get.toNamed('/register'),
                    isRoundedFull: true,
                    backgroundColor: Colors.white,
                    textColor: AppColors.textPrimary,
                  ),

                  // Note: Real social buttons would be here. Using Register link as primary alternative.
                  const SizedBox(height: 16),

                  // Terms
                  const Text(
                    '시작하기를 누르면 서비스 이용약관 및\n개인정보처리방침에 동의하는 것으로 간주됩니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textHint,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
