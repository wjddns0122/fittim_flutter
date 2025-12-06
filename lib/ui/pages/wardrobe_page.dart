import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/wardrobe_controller.dart';
import '../../core/theme/app_colors.dart';

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
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFF7F7F7),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Image.network(
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
              onTap: () {
                Get.back();
                _showUploadDialog(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text("갤러리에서 선택"),
              onTap: () {
                Get.back();
                _showUploadDialog(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadDialog(BuildContext context, ImageSource source) async {
    final file = await controller.pickImage(source);
    if (file == null) return;

    final category = '상의'.obs;
    final season = '봄'.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '새 옷 등록',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Category Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: category.value,
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(),
                  ),
                  items: ['상의', '하의', '아우터', '원피스', '신발', '가방', '악세사리']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => category.value = v!,
                ),
              ),
              const SizedBox(height: 16),
              // Season Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: season.value,
                  decoration: const InputDecoration(
                    labelText: '계절',
                    border: OutlineInputBorder(),
                  ),
                  items: ['봄', '여름', '가을', '겨울', '사계절']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => season.value = v!,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    controller.uploadItem(file, category.value, season.value),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '등록하기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
