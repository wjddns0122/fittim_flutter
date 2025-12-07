import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/main_controller.dart';
import '../../core/theme/app_colors.dart';

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
              const SizedBox(
                height: 24,
              ), // Custom spacing as per design (approx)
              // 2. Weather Widget
              _buildWeatherSection(),
              const SizedBox(height: 32),

              // 3. Hero Section (Text + Button)
              _buildHeroSection(),
              const SizedBox(height: 40),

              // 4. Selection Chips
              _buildSelectionSection(),
              const SizedBox(height: 40),

              // 5. Recent History
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
              fontSize: 13,
              fontWeight: FontWeight.w400,
              letterSpacing: 2.0, // Tracking 0.15em ~ 2.0
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
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF7F7F7),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 16,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF74A8FF).withOpacity(0.1),
            const Color(0xFF74A8FF).withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Icon
              Obx(() => _getWeatherIcon(controller.weatherCondition.value)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Temperature
                  Obx(
                    () => Text(
                      '${controller.weatherTemp.value}°C',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  // Description
                  Obx(
                    () => Text(
                      controller.weatherDescription.value,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF9C9C9C),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Obx(
            () => Text(
              controller.currentAddress.value,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF74A8FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWeatherIcon(String condition) {
    // Lucide-style icons if possible, or Material equivalents
    switch (condition) {
      case 'sunny':
      case 'clear':
        return const Icon(
          Icons.wb_sunny_outlined,
          color: Color(0xFF74A8FF),
          size: 24,
        );
      case 'rainy':
      case 'rain':
        return const Icon(
          Icons.beach_access,
          color: Color(0xFF74A8FF),
          size: 24,
        ); // cloud-rain approx
      default:
        return const Icon(
          Icons.cloud_outlined,
          color: Color(0xFF74A8FF),
          size: 24,
        );
    }
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "남들 말고,\n진짜 나를 입는 시간 10초.",
          style: GoogleFonts.poppins(
            fontSize: 28,
            height: 1.3,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "FITTIM, Fit ME.",
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2, // 0.1em
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.onCreateFittim,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100), // Full rounded
              ),
              elevation: 0,
            ),
            child: Text(
              '오늘의 FITTIM 만들기',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.15, // -0.01em
              ),
            ),
          ),
        ),
      ],
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
                    // Navigate to Fit Page (Tab 1) instead of direct Result Page
                    if (Get.isRegistered<MainController>()) {
                      Get.find<MainController>().changeIndex(1);
                    }
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
