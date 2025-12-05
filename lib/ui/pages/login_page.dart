import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller if not already present
    // In a real app with GetX bindings, this is handled in the route
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundPrimary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ), // px-8 equivalent (approx 32)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Logo
              Center(child: Text('FITTIM', style: AppTextStyles.logo)),
              const SizedBox(height: 24), // mb-6
              // Slogan
              Center(
                child: Column(
                  children: [
                    Text('남들 말고,', style: AppTextStyles.slogan),
                    const SizedBox(height: 8),
                    Text('진짜 나를 입는 시간 10초.', style: AppTextStyles.slogan),
                  ],
                ),
              ),
              const SizedBox(height: 64), // mb-16 equiv

              Center(
                child: Text(
                  'FITTIM, Fit ME.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Inputs
              _buildInput(
                controller: controller.emailController,
                placeholder: '이메일 주소',
                icon: CupertinoIcons.mail,
              ),
              const SizedBox(height: 12),
              _buildInput(
                controller: controller.passwordController,
                placeholder: '비밀번호',
                icon: CupertinoIcons.lock,
                obscureText: true,
              ),

              const SizedBox(height: 12),

              // Login Button
              Obx(
                () => CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: AppColors.buttonPrimary,
                  borderRadius: BorderRadius.circular(100), // Rounded full
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
                  child: controller.isLoading.value
                      ? const CupertinoActivityIndicator(
                          color: AppColors.buttonText,
                        )
                      : Text('시작하기', style: AppTextStyles.buttonPrimary),
                ),
              ),

              const SizedBox(height: 16),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: AppColors.border),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('또는', style: AppTextStyles.subtitle),
                  ),
                  Expanded(
                    child: Container(height: 1, color: AppColors.border),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Social Login
              _buildSocialButton(
                text: '카카오로 계속하기',
                color: AppColors.kakaoYellow,
                textColor: AppColors.kakaoText,
                onPressed: () {}, // Implement Kakao Login
              ),
              const SizedBox(height: 8),
              _buildSocialButton(
                text: 'Apple로 계속하기',
                color: AppColors.backgroundPrimary,
                textColor: AppColors.textPrimary,
                borderColor: AppColors.border,
                onPressed: () {}, // Implement Apple Login
              ),

              const SizedBox(height: 24),

              // Terms
              Text(
                '시작하기를 누르면 서비스 이용약관 및\n개인정보처리방침에 동의하는 것으로 간주됩니다.',
                textAlign: TextAlign.center,
                style: AppTextStyles.tiny,
              ),

              const SizedBox(height: 32),

              // Register Link
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Get.toNamed('/register'),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(letterSpacing: 0),
                    children: [
                      TextSpan(
                        text: '계정이 없으신가요? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextSpan(
                        text: '회원가입',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ), // adjusted for CupertinoTextField sizing
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        obscureText: obscureText,
        prefix: Icon(icon, color: AppColors.textHint, size: 20),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: null, // Remove default border
        style: AppTextStyles.input,
        placeholderStyle: AppTextStyles.input.copyWith(
          color: AppColors.textHint,
        ),
        cursorColor: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: color,
        borderRadius: BorderRadius.circular(100),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.buttonPrimary.copyWith(
            color: textColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
