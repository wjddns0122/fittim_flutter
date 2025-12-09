import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/info_card.dart';
import '../../core/widgets/style_chip.dart';
import 'profile/edit_profile_page.dart';

class MyPage extends GetView<UserController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    onPressed: () {}, // onSettings placeholder
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    // Profile Section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              size: 36,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => Text(
                              controller.user.value?.nickname ??
                                  '김민수', // Default to React mock logic
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'FITTIM, Fit ME.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textHint,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      thickness: 8,
                      color: AppColors.surface,
                      height: 24,
                    ), // Thick divider
                    // Info Section
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '내 정보',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    Get.to(() => const EditProfilePage()),
                                child: const Text(
                                  '편집',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: InfoCard(
                                      label: '키',
                                      value: controller.height.value.isNotEmpty
                                          ? '${controller.height.value}cm'
                                          : '-',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: InfoCard(
                                      label: '몸무게',
                                      value: controller.weight.value.isNotEmpty
                                          ? '${controller.weight.value}kg'
                                          : '-',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: InfoCard(
                                      label: '체형',
                                      value:
                                          controller.bodyType.value.isNotEmpty
                                          ? ({
                                                  'SLIM': '마름',
                                                  'AVERAGE': '보통',
                                                  'CHUBBY': '통통',
                                                  'MUSCULAR': '근육질',
                                                }[controller.bodyType.value] ??
                                                '보통')
                                          : '-',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Style Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '스타일',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '선호 스타일',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF6B6B6B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.preferredStyles
                                  .map((s) => StyleChip(label: s))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '선호 쇼핑몰',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF6B6B6B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.preferredMalls
                                  .map((s) => StyleChip(label: s))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(
                      thickness: 8,
                      color: AppColors.surface,
                      height: 24,
                    ),

                    // App Settings
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '앱 설정',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildSettingItem('코디 히스토리'),
                          _buildSettingItem('알림 설정'),
                          _buildSettingItem('언어'),
                          _buildSettingItem('로그아웃', onTap: controller.logout),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
