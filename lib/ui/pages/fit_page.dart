import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fit_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common_button.dart';
import '../../core/widgets/fashion_card.dart';

class FitPage extends GetView<FitController> {
  const FitPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FitController>()) {
      Get.put(FitController());
    }

    final seasons = ['봄', '여름', '가을', '겨울'];
    final places = ['데이트', '학교', '여행', '파티']; // Extended Context

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Fit Recommendation', style: AppTextStyles.headline2),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Obx(() {
          // If no result yet, show Input Form
          if (controller.recommendation.value == null) {
            return _buildInputForm(seasons, places);
          }
          // If loading, show spinner
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          // Show Result
          return _buildLookbookResult(context);
        }),
      ),
    );
  }

  Widget _buildInputForm(List<String> seasons, List<String> places) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('오늘의 TPO를\n설정해주세요.', style: AppTextStyles.headline1),
          const SizedBox(height: 40),

          Text('계절 (Season)', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: seasons.map((season) {
              return Obx(() {
                final isSelected = controller.selectedSeason.value == season;
                return ChoiceChip(
                  label: Text(season),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: AppTextStyles.body2.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) controller.selectedSeason.value = season;
                  },
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                  ),
                );
              });
            }).toList(),
          ),

          const SizedBox(height: 24),

          Text('장소 (Place)', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: places.map((place) {
              return Obx(() {
                final isSelected = controller.selectedPlace.value == place;
                return ChoiceChip(
                  label: Text(place),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: AppTextStyles.body2.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) controller.selectedPlace.value = place;
                  },
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                  ),
                );
              });
            }).toList(),
          ),

          const Spacer(),

          CommonButton(
            text: '추천받기',
            onPressed: () => controller.getRecommendation(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLookbookResult(BuildContext context) {
    final result = controller.recommendation.value!;

    return Column(
      children: [
        // Header Context
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag('#${controller.selectedSeason.value}'),
              const SizedBox(width: 8),
              _buildTag('#${controller.selectedPlace.value}'),
              const SizedBox(width: 8),
              _buildTag('#OOTD'),
            ],
          ),
        ),

        // Scrollable Outfit Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Today's Look",
                  style: AppTextStyles.headline1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Hero Item (Outer if exists)
                if (result.outer != null) ...[
                  SizedBox(
                    height: 300,
                    child: FashionCard(
                      imageUrl: controller.getFullImageUrl(
                        result.outer!.imageUrl,
                      ),
                      title: 'OUTER',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Row for Top & Bottom using robust null checks
                if (result.top != null || result.bottom != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (result.top != null)
                        Expanded(
                          child: SizedBox(
                            height: 220,
                            child: FashionCard(
                              imageUrl: controller.getFullImageUrl(
                                result.top!.imageUrl,
                              ),
                              title: 'TOP',
                            ),
                          ),
                        ),

                      if (result.top != null && result.bottom != null)
                        const SizedBox(width: 16),

                      if (result.bottom != null)
                        Expanded(
                          child: SizedBox(
                            height: 220,
                            child: FashionCard(
                              imageUrl: controller.getFullImageUrl(
                                result.bottom!.imageUrl,
                              ),
                              title: 'BOTTOM',
                            ),
                          ),
                        ),
                    ],
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => controller.getRecommendation(),
                    icon: const Icon(
                      Icons.refresh,
                      color: AppColors.textPrimary,
                    ),
                    label: Text(
                      'Retry',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: CommonButton(
                  text: 'Save Look',
                  onPressed: () => controller.saveLook(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyles.body2.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
