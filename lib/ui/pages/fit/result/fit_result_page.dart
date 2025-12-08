import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/api_provider.dart';
import '../../../../data/models/wardrobe_item.dart';
import 'fit_result_controller.dart';

class FitResultPage extends GetView<FitResultController> {
  const FitResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered if not already
    if (!Get.isRegistered<FitResultController>()) {
      Get.put(FitResultController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '코디 상세',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              // Share logic
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero Section (Image + Heart)
                  _buildHeroSection(),

                  // 2. Title & Tags
                  _buildTitleSection(),

                  const Divider(height: 1, color: Color(0xFFEEEEEE)),

                  // 3. Items Section
                  _buildItemsSection(),
                ],
              );
            }),
          ),

          // 4. Fixed Bottom Bar
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Main Image
        Container(
          width: double.infinity,
          height: 400, // Fixed height or AspectRatio
          decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
          child: Obx(() {
            final url = controller.mainImageUrl.value;
            if (url.isEmpty) {
              return const Center(
                child: Icon(Icons.checkroom, size: 48, color: Colors.grey),
              );
            }
            return Image.network(
              _getFullUrl(url),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            );
          }),
        ),

        // Floating Heart Button
        Positioned(
          right: 20,
          bottom: 20,
          child: Obx(
            () => GestureDetector(
              onTap: controller.toggleSaved,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  controller.isSaved.value
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isSaved.value ? Colors.red : Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              '데일리 ${controller.mood.value.isNotEmpty ? controller.mood.value : "캐주얼"} 룩',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (controller.place.value.isNotEmpty)
                  _buildTag('#${controller.place.value}'),
                if (controller.mood.value.isNotEmpty)
                  _buildTag('#${controller.mood.value}'),
                if (controller.season.value.isNotEmpty)
                  _buildTag('#${controller.season.value}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF5FF), // Light Blue
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF007AFF), // Blue
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildItemsSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stylist's Comment Section
          // Stylist's Comment Section
          Obx(() {
            final comment = controller.reason.value.isNotEmpty
                ? controller.reason.value
                : "저장된 추천 사유가 없습니다";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stylist's Comment",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        size: 20,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          comment,
                          style: TextStyle(
                            fontSize: 14,
                            color: controller.reason.value.isNotEmpty
                                ? const Color(0xFF555555)
                                : Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          }),

          Text(
            '구성 아이템',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          Obx(() {
            final items = controller.generatedItems;

            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('표시할 아이템 정보가 없습니다.')),
              );
            }

            return Column(
              children: items.map((item) => _buildItemCard(item)).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItemCard(WardrobeItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: const Color(0xFFF7F7F7),
              child: Image.network(
                _getFullUrl(item.imageUrl),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Assuming generic name/brand as WardrobeItem might be minimal
                // Using placeholder or generic text if fields missing
                Text(
                  '${item.season} Basic Item', // Using season as proxy for name
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Fittim Brand', // Placeholder brand
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Arrow Icon
          const Icon(Icons.chevron_right, color: Color(0xFFE0E0E0)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10), // Safe area inset approx
        child: Row(
          children: [
            // Save Outline Button
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(64, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Icon(Icons.bookmark_border, color: Colors.black),
            ),
            const SizedBox(width: 12),

            // Shop Link Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Go to shop
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '상품 보러가기',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFullUrl(String path) {
    if (path.startsWith('http')) return path;
    return '${ApiProvider.baseUrl}$path';
  }
}
