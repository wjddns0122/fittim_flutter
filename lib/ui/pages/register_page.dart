import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundPrimary,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('회원가입'),
        backgroundColor: AppColors.backgroundPrimary,
        border: null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),

              Text(
                '환영합니다!',
                style: AppTextStyles.heroHeading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '프로필을 설정하고\nFITTIM을 시작해보세요.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Inputs
              _buildInput(
                controller: controller.nameController,
                placeholder: '닉네임',
                icon: CupertinoIcons.person,
              ),
              const SizedBox(height: 12),
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

              const SizedBox(height: 32),

              // Register Button
              Obx(
                () => CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: AppColors.buttonPrimary,
                  borderRadius: BorderRadius.circular(100),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.register,
                  child: controller.isLoading.value
                      ? const CupertinoActivityIndicator(
                          color: AppColors.buttonText,
                        )
                      : Text('가입하기', style: AppTextStyles.buttonPrimary),
                ),
              ),

              const Spacer(flex: 2),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        obscureText: obscureText,
        prefix: Icon(icon, color: AppColors.textHint, size: 20),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: null,
        style: AppTextStyles.input,
        placeholderStyle: AppTextStyles.input.copyWith(
          color: AppColors.textHint,
        ),
        cursorColor: AppColors.textPrimary,
      ),
    );
  }
}
