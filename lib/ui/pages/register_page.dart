import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common_button.dart';
import '../../core/widgets/common_text_field.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '환영합니다!\n기본 정보를 입력해주세요.',
                style: AppTextStyles.headline1.copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 40),

              _buildLabel('이름 (Nickname)'),
              const SizedBox(height: 8),
              CommonTextField(
                controller: controller.nameController,
                hintText: '닉네임을 입력해주세요',
                isRoundedFull: true,
              ),
              const SizedBox(height: 24),

              _buildLabel('이메일 (Email)'),
              const SizedBox(height: 8),
              CommonTextField(
                controller: controller.emailController,
                hintText: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                isRoundedFull: true,
              ),
              const SizedBox(height: 24),

              _buildLabel('비밀번호 (Password)'),
              const SizedBox(height: 8),
              Obx(
                () => CommonTextField(
                  controller: controller.passwordController,
                  hintText: '비밀번호를 입력해주세요',
                  obscureText: !controller.isPasswordVisible.value,
                  isRoundedFull: true,
                ),
              ),

              const SizedBox(height: 48),

              Obx(
                () => CommonButton(
                  text: '가입하기',
                  onPressed: controller.register,
                  isLoading: controller.isLoading.value,
                  isRoundedFull: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.body2.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}
