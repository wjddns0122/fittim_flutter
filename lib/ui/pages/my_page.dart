import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../core/theme/app_colors.dart';

class MyPage extends GetView<UserController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false, // Left align per React
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.surface, // #F7F7F7
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
                        controller.user.value?.nickname ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
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
                      ), // tracking 0.05em
                    ),
                  ],
                ),
              ),

              const Divider(thickness: 8, color: AppColors.surface), // Divider
              // Menu Options
              _buildMenuSection(
                title: '내 정보',
                children: [_buildMenuItem(context, '편집', onTap: () {})],
              ),

              const Divider(thickness: 8, color: AppColors.surface),

              _buildMenuSection(
                title: '앱 설정',
                children: [
                  _buildMenuItem(
                    context,
                    '코디 히스토리',
                    onTap: () {},
                    showArrow: true,
                  ),
                  _buildMenuItem(
                    context,
                    '알림 설정',
                    onTap: () {},
                    showArrow: true,
                  ),
                  _buildMenuItem(context, '언어', onTap: () {}, showArrow: true),
                  _buildMenuItem(
                    context,
                    '로그아웃',
                    onTap: controller.logout,
                    showArrow: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title, {
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppColors.textPrimary,
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
                size: 20,
              )
            else if (title == '편집')
              const Text(
                '편집',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textHint,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
