import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_button.dart';
import '../../core/widgets/common_text_field.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SignupController>()) {
      Get.put(SignupController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: controller.previousPage,
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Indicator (Optional, visual cue)
            Obx(
              () => LinearProgressIndicator(
                value: (controller.currentStep.value + 1) / 3,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 2,
              ),
            ),

            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(context),
                  _buildStep2(context),
                  _buildStep3(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Email Input
  Widget _buildStep1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이메일을 입력해주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '인증 코드를 보내드릴게요.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 48),

          CommonTextField(
            controller: controller.emailController,
            hintText: 'user@example.com',
            keyboardType: TextInputType.emailAddress,
            isRoundedFull: true,
            prefixIcon: const Icon(
              Icons.mail_outline,
              color: AppColors.textHint,
              size: 20,
            ),
          ),

          const Spacer(),

          Obx(
            () => CommonButton(
              text: '인증 코드 받기',
              onPressed: controller.requestVerificationCode,
              isLoading: controller.isLoading.value,
              isRoundedFull: true,
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Verification Code
  Widget _buildStep2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '인증 코드를 입력해주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.emailController.text}로 전송된\n6자리 코드를 입력해주세요.',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 48),

          CommonTextField(
            controller: controller.codeController,
            hintText: '인증 코드 6자리',
            keyboardType: TextInputType.number,
            isRoundedFull: true,
            prefixIcon: const Icon(
              Icons.lock_clock_outlined,
              color: AppColors.textHint,
              size: 20,
            ),
          ),

          const Spacer(),

          Obx(
            () => CommonButton(
              text: '확인',
              onPressed: controller.verifyCode,
              isLoading: controller.isLoading.value,
              isRoundedFull: true,
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Password & Nickname
  Widget _buildStep3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SingleChildScrollView requires constraints or column
            SizedBox(
              height:
                  MediaQuery.of(context).size.height -
                  150, // Available height minus header approx
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '마지막 단계예요!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '비밀번호와 닉네임을 설정해주세요.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 48),

                  CommonTextField(
                    controller: controller.passwordController,
                    hintText: '비밀번호 (6자리 이상)',
                    obscureText: true,
                    isRoundedFull: true,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CommonTextField(
                    controller: controller.nicknameController,
                    hintText: '닉네임',
                    isRoundedFull: true,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                  ),

                  const Spacer(),

                  Obx(
                    () => CommonButton(
                      text: '가입 완료',
                      onPressed: controller.completeSignup,
                      isLoading: controller.isLoading.value,
                      isRoundedFull: true,
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
