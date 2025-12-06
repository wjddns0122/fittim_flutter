import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/main_controller.dart';
import '../../core/theme/app_colors.dart';
import 'fit/result/fit_result_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              _buildHeader(),
              const SizedBox(height: 32),

              // 2. Main Button
              _buildMainButton(),
              const SizedBox(height: 32),

              // 3. Selection Chips
              _buildSelectionSection(),
              const SizedBox(height: 40),

              // 4. Recent History
              _buildHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  // Header: Logo centered, User icon right
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Center Logo
        Center(
          child: Text(
            'FITTIM',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        // Right Icon
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () => Get.find<MainController>().changeIndex(4), // MyPage
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.person_outline, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.onCreateFittim,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          '오늘의 FITTIM 만들기',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionGroup(
          question: '오늘 계절은?',
          options: ['봄', '여름', '가을', '겨울'],
          selectedRx: controller.selectedSeason,
        ),
        const SizedBox(height: 24),
        _buildQuestionGroup(
          question: '오늘 어디 가?',
          options: ['캠퍼스', '출근', '데이트', '카페', '집앞'],
          selectedRx: controller.selectedPlace,
        ),
        const SizedBox(height: 24),
        _buildQuestionGroup(
          question: '오늘 무드는?',
          options: ['꾸안꾸', '미니멀', '스트릿', '깔끔'],
          selectedRx: controller.selectedMood,
        ),
      ],
    );
  }

  Widget _buildQuestionGroup({
    required String question,
    required List<String> options,
    required RxString selectedRx,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return Obx(() {
              final isSelected = selectedRx.value == option;
              return GestureDetector(
                onTap: () => selectedRx.value = option,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.black
                          : const Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 생성한 코디',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220, // Adjust height for 3:4 aspect ratio + text
          child: Obx(() {
            if (controller.fitHistoryList.isEmpty) {
              return Center(
                child: Text(
                  '아직 생성된 코디가 없어요.',
                  style: GoogleFonts.poppins(
                    color: AppColors.textHint,
                    fontSize: 14,
                  ),
                ),
              );
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.fitHistoryList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final historyItem = controller.fitHistoryList[index];
                // Assuming historyItem has 'imageUrl', 'title' or we derive it
                // If backend returns plain object, adjust parsing.
                // Placeholder logic:
                final imageUrl = historyItem['imageUrl'] ?? '';
                final title = historyItem['title'] ?? '생성된 코디';

                return GestureDetector(
                  onTap: () {
                    // Navigate to FitResultPage with the history item as arguments
                    // The FitResultController is designed to parse this object/map.
                    Get.to(() => const FitResultPage(), arguments: historyItem);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xFFF7F7F7),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      controller.getFullImageUrl(imageUrl),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.checkroom,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
