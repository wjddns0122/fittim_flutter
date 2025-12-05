import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/wardrobe_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/fashion_card.dart';

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
            // Header: "내 옷장" + Plus Button
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 24,
              ), // pt-14 pb-6 in React (approx)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '내 옷장',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showAddOptions(context),
                    child: Container(
                      width: 36, // w-9
                      height: 36, // h-9
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category Tabs
            Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: WardrobeController.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 24),
                itemBuilder: (context, index) {
                  final category = WardrobeController.categories[index];
                  // Map EN codes to KR labels for display, if needed, or just use as is if they match
                  // React has: 'ALL', '상의', '하의' etc. My Controller has 'ALL', 'TOP' etc.
                  // I should map them for display to match visual clone.
                  final label = _getCategoryLabel(category);

                  return Obx(() {
                    final isSelected =
                        controller.selectedCategory.value == category;
                    return GestureDetector(
                      onTap: () => controller.changeCategory(category),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w400
                                  : FontWeight.w300,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              height: 1.5,
                              width: 30, // rough width or use LayoutBuilder
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ),

            // Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    0,
                    24,
                    128,
                  ), // pb-32 = 128px approx
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1, // aspect-square
                  ),
                  itemCount: controller.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredItems[index];
                    return FashionCard(
                      imageUrl: controller.getFullImageUrl(item.imageUrl),
                      title: item
                          .category, // React uses 'name' (e.g. White Shirt), we have 'category', using category/season as fallback title
                      subtitle: item.season,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      // Floating Action Button (Brand Blue Sparkles)
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 50,
          right: 8,
        ), // bottom-24 right-6
        child: SizedBox(
          width: 56, // w-14
          height: 56, // h-14
          child: FloatingActionButton(
            onPressed: () {
              // FAB Logic or duplicate Add
              _showAddOptions(context);
            },
            backgroundColor: AppColors.brandBlue,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
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
