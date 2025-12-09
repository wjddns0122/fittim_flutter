import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/wardrobe_controller.dart';
import '../../core/theme/app_colors.dart';
import 'wardrobe/add_clothing_page.dart';
import 'wardrobe/wardrobe_detail_page.dart';

class WardrobePage extends GetView<WardrobeController> {
  const WardrobePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WardrobeController>()) {
      Get.put(WardrobeController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header: "My Wardrobe" + Plus Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Wardrobe',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ), // Placeholder to keep title left or just remove row alignment logic if needed
                ],
              ),
            ),

            // Category Tabs
            Container(
              height: 36,
              margin: const EdgeInsets.only(bottom: 24),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: WardrobeController.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = WardrobeController.categories[index];
                  final label = _getCategoryLabel(category);

                  return Obx(() {
                    final isSelected =
                        controller.selectedCategory.value == category;
                    return GestureDetector(
                      onTap: () => controller.changeCategory(category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF888888),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            // Masonry Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // MasonryGridView needs finite height or be in expanded, which it is.
                return MasonryGridView.count(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount:
                      controller.items.length, // Filter is done via API now
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return GestureDetector(
                      onTap: () => Get.to(() => WardrobeDetailPage(item: item)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFF7F7F7),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Hero(
                                tag: 'wardrobe_${item.id}',
                                child: Image.network(
                                  controller.getFullImageUrl(item.imageUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      height: 150,
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Color(0xFFCCCCCC),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Optional Overlay
                              Positioned(
                                bottom: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item.season,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 8),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            onPressed: () => _showAddOptions(context),
            backgroundColor: Colors.black, // Primary color
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  String _getCategoryLabel(String code) {
    switch (code) {
      case 'ALL':
        return 'ALL';
      case 'TOP':
        return '상의';
      case 'BOTTOM':
        return '하의';
      case 'OUTER':
        return '아우터';
      case 'SHOES':
        return '신발';
      case 'ACC':
        return '악세사리';
      default:
        return code;
    }
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text("사진 촬영"),
              onTap: () async {
                Get.back();
                final file = await controller.pickImage(ImageSource.camera);
                if (file != null) {
                  Get.to(() => AddClothingPage(imageFile: file));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text("갤러리에서 선택"),
              onTap: () async {
                Get.back();
                final file = await controller.pickImage(ImageSource.gallery);
                if (file != null) {
                  Get.to(() => AddClothingPage(imageFile: file));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
