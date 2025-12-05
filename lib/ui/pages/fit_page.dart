import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fit_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/fit_response.dart';
import '../../data/models/wardrobe_item.dart';

class FitPage extends GetView<FitController> {
  const FitPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FitController>()) {
      Get.put(FitController());
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          '오늘의 핏',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Selector Section
              _buildInputSection(),

              const SizedBox(height: 20),

              const Divider(thickness: 1, color: AppColors.border),

              const SizedBox(height: 20),

              // 2. Result Section
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonPrimary,
                      ),
                    );
                  }

                  if (controller.recommendation.value == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.checkroom,
                            size: 48,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "오늘 뭐 입을지 고민되나요?\n계절을 선택하고 추천을 받아보세요!",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildResultView(controller.recommendation.value!);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedSeason.value,
                  isExpanded: true,
                  items: ['봄', '여름', '가을', '겨울'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: AppTextStyles.body),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedSeason.value = val;
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => controller.getRecommendation(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            '추천받기',
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(FitResponse fit) {
    // fit is FitResponse
    return SingleChildScrollView(
      child: Column(
        children: [
          if (fit.outer != null) ...[
            _buildItemCard(fit.outer!, 'OUTER'),
            const SizedBox(height: 10),
            const Icon(Icons.add, color: AppColors.textHint, size: 20),
            const SizedBox(height: 10),
          ],

          if (fit.top != null) _buildItemCard(fit.top!, 'TOP'),

          const SizedBox(height: 10),
          const Icon(Icons.add, color: AppColors.textHint, size: 20),
          const SizedBox(height: 10),

          if (fit.bottom != null) _buildItemCard(fit.bottom!, 'BOTTOM'),

          const SizedBox(height: 30),

          TextButton.icon(
            onPressed: () => controller.getRecommendation(),
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            label: Text('다른 코디 보기', style: AppTextStyles.body),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItemCard(WardrobeItem item, String label) {
    return Container(
      width: double.infinity,
      height: 200, // Fixed height for consistency
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              controller.getFullImageUrl(item.imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => const Center(
                child: Icon(Icons.broken_image, color: AppColors.textHint),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: AppTextStyles.tiny.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
