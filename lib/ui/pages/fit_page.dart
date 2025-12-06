import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fit_controller.dart';
import '../../controllers/main_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_button.dart';
import '../../core/widgets/chip_group.dart';
import '../../core/widgets/tag_chip.dart';
// removed unused fashion_card import
import 'fit/result/fit_result_page.dart';

class FitPage extends GetView<FitController> {
  final bool isHomeMode;

  const FitPage({super.key, this.isHomeMode = true});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FitController>()) {
      Get.put(FitController());
    }

    final seasons = ['봄', '여름', '가을', '겨울', '사계절'];
    final locations = ['캠퍼스', '출근', '데이트', '카페', '집앞'];
    final moods = ['꾸안꾸', '미니멀', '스트릿', '깔끔'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isHomeMode
            ? _buildHomeView(context, seasons, locations, moods)
            : _buildResultView(context),
      ),
    );
  }

  // === HOME MODE (Input View) ===
  Widget _buildHomeView(
    BuildContext context,
    List<String> seasons,
    List<String> locations,
    List<String> moods,
  ) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: 24,
          ), // pt-14 pb-6
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 36), // Spacer alignment
              const Text(
                'FITTIM',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight
                      .bold, // font-bold ??? React uses tracking-[0.15em] but font weight default?
                  // React: font-bold is not specified on title "FITTIM", but tracking is high.
                  // I'll stick to my previous bold or try matching standard.
                  // React: tracking-[0.15em] -> FitPage.dart had bold. Let's start with standard.
                  letterSpacing: 2.0, // 13 * 0.15 ~ 1.95
                  color: AppColors.textPrimary,
                ),
              ),
              // Profile Icon Button
              GestureDetector(
                onTap: () {
                  Get.find<MainController>().changeIndex(4); // Go to MyPage
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.surface, // #F7F7F7
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 16, // w-4 h-4
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable Body
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weather Widget
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ), // px-8 pt-2 pb-4
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        // Gradient colors
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
                              color: AppColors.brandBlue,
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
                            color: AppColors.brandBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    32,
                    16,
                    32,
                    40,
                  ), // px-8 pt-4 pb-10
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
                      const SizedBox(height: 12), // mb-3
                      const Text(
                        'FITTIM, Fit ME.',
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 32), // mb-8
                      CommonButton(
                        text: '오늘의 FITTIM 만들기',
                        onPressed: () async {
                          await controller.getRecommendation();
                          // Switch to Fit Tab (Index 1)
                          Get.find<MainController>().changeIndex(1);
                        },
                        isLoading:
                            controller.isLoading.value, // Bind loading state
                        backgroundColor: AppColors.primary,
                        isRoundedFull: true,
                      ),
                    ],
                  ),
                ),

                // Chip Groups (Input)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => ChipGroup(
                          label:
                              '지금 계절은?', // Used Seasons here per controller logic, React used Locations in first slot but logic flexible
                          // React: Location -> Mood. My Logic: Season -> Place.
                          // I will map visuals: "지금 계절은?" (Season), "오늘 어디 가?" (Location)
                          chips: seasons,
                          selected: controller.selectedSeason.value,
                          onSelect: (val) =>
                              controller.selectedSeason.value = val,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(
                        () => ChipGroup(
                          label: '오늘 어디 가?',
                          chips: locations,
                          selected: controller.selectedPlace.value,
                          onSelect: (val) =>
                              controller.selectedPlace.value = val,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Mood Placeholder
                      ChipGroup(
                        label: '오늘 무드는?',
                        chips: moods,
                        selected: '꾸안꾸', // Static for now
                        onSelect: (val) {},
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),

                // Recent Outfits (Horizontal Scroll Placeholder)
                Padding(
                  padding: const EdgeInsets.only(left: 32, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '최근 생성한 코디',
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 0.65, // tracking 0.05em
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildRecentOutfitCard('오늘의 캠퍼스 룩'),
                            _buildRecentOutfitCard('데이트 코디'),
                            _buildRecentOutfitCard('미니멀 출근룩'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOutfitCard(String title) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Icon(Icons.image, color: AppColors.textHint),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }

  // === RESULT VIEW (Fit Tab) ===
  Widget _buildResultView(BuildContext context) {
    return Obx(() {
      // If loading
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }
      // If no data
      if (controller.recommendation.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.checkroom_outlined,
                size: 48,
                color: AppColors.textHint,
              ),
              const SizedBox(height: 16),
              const Text(
                "생성된 코디가 없습니다.",
                style: TextStyle(color: AppColors.textHint),
              ),
              TextButton(
                onPressed: () {
                  Get.find<MainController>().changeIndex(0); // Go to Home
                },
                child: const Text(
                  "코디 생성하러 가기",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        );
      }

      // Data Available
      final result = controller.recommendation.value!;
      final mainImage = result.outer?.imageUrl ?? result.top?.imageUrl ?? '';
      // Mimicking OutfitResultsScreen header and list
      return Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.find<MainController>().changeIndex(0),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  '오늘의 FITTIM',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                const Icon(
                  Icons.tune,
                  color: AppColors.textPrimary,
                ), // SlidersHorizontal
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  '오늘을 위한 코디를 준비했어요.', // Intro
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 20),

                // Card 1
                _buildResultCard(
                  title: '오늘의 ${controller.selectedPlace.value} 룩',
                  items: [
                    if (result.outer != null) result.outer!.category,
                    if (result.top != null) result.top!.category,
                    if (result.bottom != null) result.bottom!.category,
                  ],
                  tags: [
                    '#${controller.selectedPlace.value}',
                    '#${controller.selectedSeason.value}',
                  ],
                  imageUrl: mainImage,
                ),

                const SizedBox(height: 24),

                // Regenerate Button
                CommonButton(
                  text: '다시 생성',
                  onPressed: controller.getRecommendation,
                  backgroundColor: Colors.white,
                  textColor: AppColors.textPrimary,
                  isRoundedFull: true,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildResultCard({
    required String title,
    required List<String> items,
    required List<String> tags,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Use controller.recommendation.value
              // It's a FitResponse object. FitResultController can handle it (dynamic logic).
              // Or convert to Map if needed, but Controller logic handles Object with field checks.
              // FitResultController uses `_hasField` so FitResponse object works if it has generic getters or toMap.
              // Actually FitResponse likely has standard getters.
              // FitResultController uses dynamic access `args.top`.
              // If FitResponse has `top` getter, it works.
              Get.to(
                () => const FitResultPage(),
                arguments: controller.recommendation.value,
              );
            },
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Container(
                color: AppColors.surface,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        controller.getFullImageUrl(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Icon(Icons.image, color: AppColors.textHint),
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
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ...items.map(
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
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
                          i,
                          style: const TextStyle(
                            color: Color(0xFF6B6B6B),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: tags.map((t) => TagChip(text: t)).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildOutlineActionBtn(
                        Icons.bookmark_border,
                        '저장',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: _buildOutlineActionBtn(Icons.share, '공유')),
                  ],
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '비슷한 코디 다시 추천',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineActionBtn(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16, color: AppColors.textPrimary),
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    );
  }
}
