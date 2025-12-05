import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fit_controller.dart';
import '../../core/theme/app_colors.dart';
// removed unused app_text_styles import
import '../../core/widgets/common_button.dart';
import '../../core/widgets/chip_group.dart';
import '../../core/widgets/tag_chip.dart';

class FitPage extends GetView<FitController> {
  const FitPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FitController>()) {
      Get.put(FitController());
    }

    final seasons = ['봄', '여름', '가을', '겨울', '사계절'];
    final locations = ['캠퍼스', '출근', '데이트', '카페', '집앞', '여행'];
    final moods = ['꾸안꾸', '미니멀', '스트릿', '깔끔', '페미닌'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.recommendation.value != null) {
            return _buildLookbookResult(context);
          }
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return _buildInputForm(seasons, locations, moods);
        }),
      ),
    );
  }

  Widget _buildInputForm(
    List<String> seasons,
    List<String> locations,
    List<String> moods,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Text(
                  'FITTIM',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF74A8FF).withValues(alpha: 0.1),
                    const Color(0xFF74A8FF).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.cloud_outlined,
                        color: Color(0xFF74A8FF),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '18°C',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '구름 많음',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    '서울, 강남구',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF74A8FF),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '남들 말고,\n진짜 나를 입는 시간 10초.',
                  style: TextStyle(
                    fontSize: 28,
                    height: 1.3,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'FITTIM, Fit ME.',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                CommonButton(
                  text: '오늘의 FITTIM 만들기',
                  onPressed: () => controller.getRecommendation(),
                  backgroundColor: AppColors.primary,
                  isRoundedFull: true,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => ChipGroup(
                    label: '지금 계절은?',
                    chips: seasons,
                    selected: controller.selectedSeason.value,
                    onSelect: (val) => controller.selectedSeason.value = val,
                  ),
                ),
                const SizedBox(height: 24),

                Obx(
                  () => ChipGroup(
                    label: '오늘 어디 가?',
                    chips: locations,
                    selected: controller.selectedPlace.value,
                    onSelect: (val) => controller.selectedPlace.value = val,
                  ),
                ),
                const SizedBox(height: 24),

                ChipGroup(
                  label: '오늘 무드는?',
                  chips: moods,
                  selected: '꾸안꾸',
                  onSelect: (val) {},
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLookbookResult(BuildContext context) {
    final result = controller.recommendation.value!;
    final outfitName = '오늘의 ${controller.selectedPlace.value} 룩';
    final items = [
      if (result.outer != null) result.outer!.category,
      if (result.top != null) result.top!.category,
      if (result.bottom != null) result.bottom!.category,
      '아이템 추천',
    ];
    final tags = [
      '#${controller.selectedPlace.value}',
      '#${controller.selectedSeason.value}',
      '#데일리',
    ];
    final mainImage = result.outer?.imageUrl ?? result.top?.imageUrl ?? '';

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        AppBar(
          title: const Text(
            '오늘의 FITTIM',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.05,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: controller.clearRecommendation,
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: const Text(
            '오늘을 위한 코디를 준비했어요.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.textHint,
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF0F0F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 4 / 5,
                child: Container(
                  color: AppColors.surface,
                  child: mainImage.isNotEmpty
                      ? Image.network(
                          controller.getFullImageUrl(mainImage),
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Icon(
                            Icons.checkroom,
                            size: 48,
                            color: AppColors.textHint,
                          ),
                        ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      outfitName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              item,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF6B6B6B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) => TagChip(text: tag)).toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => controller.saveLook(),
                            icon: const Icon(
                              Icons.bookmark_border,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                            label: const Text(
                              '저장',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                            label: const Text(
                              '공유',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => controller.getRecommendation(),
                        child: const Text(
                          '비슷한 코디 다시 추천',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: () => controller.getRecommendation(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              '다시 생성',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
