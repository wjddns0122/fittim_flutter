import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Logo & Slogan
              Text(
                'FITTIM',
                textAlign: TextAlign.center,
                style: AppTextStyles.headline1.copyWith(
                  fontSize: 42,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '남들 말고,\n진짜 나를 입는 시간 10초.',
                textAlign: TextAlign.center,
                style: AppTextStyles.headline2.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),

              const Spacer(flex: 1),

              // Input Fields
              _buildTextField(
                controller: controller.emailController,
                placeholder: '이메일 주소',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: controller.passwordController,
                placeholder: '비밀번호',
                obscureText: true,
              ),

              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textInverse,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: Text('시작하기', style: AppTextStyles.button),
              ),

              const SizedBox(height: 12),

              // Kakao Login (Hardcoded colors for 3rd party brand)
              ElevatedButton(
                onPressed: () {
                  Get.snackbar('알림', '카카오 로그인은 준비 중입니다.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEE500),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: Text(
                  '카카오로 계속하기',
                  style: AppTextStyles.button.copyWith(color: Colors.black),
                ),
              ),

              const Spacer(flex: 2),

              // Signup Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('아직 회원이 아니신가요?', style: AppTextStyles.body2),
                  TextButton(
                    onPressed: () => Get.toNamed('/register'),
                    child: Text(
                      '회원가입',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    // Using simple CupertinoTextField for iOS feel or TextField for Material
    // Given Material Theme switch, I'll use TextField but styled to look like the design
    // The design requested "Cupertino" feel but now we are "Minimal/Sophisticated".
    // I'll use TextField with InputDecorationTheme defined in AppTheme.
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: placeholder, // using hintText instead of placeholder
        fillColor: AppColors.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            30,
          ), // Rounded full as per StadiumBorder buttons
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      style: AppTextStyles.body1,
    );
  }
}
