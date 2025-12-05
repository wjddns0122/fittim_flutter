import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/wardrobe_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/fashion_card.dart';

class WardrobePage extends GetView<WardrobeController> {
  const WardrobePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WardrobeController>()) {
      Get.put(WardrobeController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header (React: px-6 pt-14 pb-6 -> SafeArea takes care of pt)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '내 옷장',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  // Small Plus Button
                  InkWell(
                    onTap: () => _showImageSourceActionSheet(context),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.textPrimary, // #1A1A1A
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

            // Tab Filter (React: border-b border-[#F0F0F0])
            Container(
              height: 40, // Reduced height for tab style
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: WardrobeController.categories.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 24), // gap-6
                itemBuilder: (context, index) {
                  final cat = WardrobeController.categories[index];
                  return Obx(() {
                    final isSelected = controller.selectedCategory.value == cat;
                    return InkWell(
                      onTap: () => controller.changeCategory(cat),
                      overlayColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cat,
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
                          // Active Indicator
                          if (isSelected)
                            Container(
                              height: 1.5,
                              width: cat.length * 12.0 + 10, // Approx width
                              color: AppColors.textPrimary,
                            )
                          else
                            const SizedBox(height: 1.5),
                        ],
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 10),

            // Clothes Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (controller.filteredItems.isEmpty) {
                  return Center(
                    child: Text(
                      'No items in this category',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    16,
                    24,
                    100,
                  ), // Bottom padding for FAB
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16, // gap-4
                    mainAxisSpacing: 24, // gap-y
                    childAspectRatio: 0.8, // Adjusted for image + text
                  ),
                  itemCount: controller.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredItems[index];
                    return FashionCard(
                      imageUrl: controller.getFullImageUrl(item.imageUrl),
                      title:
                          item.category, // Using category as name placeholder
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      // Floating Action Button (#74A8FF)
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24, right: 6),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            onPressed: () => _showImageSourceActionSheet(context),
            backgroundColor: AppColors.brandBlue,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
            ), // Sparkles icon approx
          ),
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    if (kIsWeb) {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.background,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColors.textPrimary,
                ),
                title: Text('카메라로 촬영', style: AppTextStyles.body1),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.textPrimary,
                ),
                title: Text('앨범에서 선택', style: AppTextStyles.body1),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('옷 등록하기'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
              child: const Text('카메라로 촬영'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
              child: const Text('앨범에서 선택'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Get.back(),
            isDestructiveAction: true,
            child: const Text('취소'),
          ),
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await controller.pickImage(source);
    if (file != null) {
      _showDetailsDialog(file);
    }
  }

  void _showDetailsDialog(XFile imageFile) {
    final categories = ['상의', '하의', '아우터', '원피스', '신발', '가방', '기타'];
    final seasons = ['봄', '여름', '가을', '겨울', '사계절'];

    String selectedCategory = categories[0];
    String selectedSeason = seasons[0];

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '새로운 옷 등록',
                  style: AppTextStyles.headline2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Image Preview
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Use 10px consistent with theme
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: kIsWeb
                          ? Image.network(imageFile.path, fit: BoxFit.cover)
                          : Image.file(File(imageFile.path), fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: selectedCategory,
                          decoration: InputDecoration(
                            labelText: '카테고리',
                            fillColor: AppColors.surface,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // 10px
                              borderSide: BorderSide.none,
                            ),
                          ),
                          dropdownColor: AppColors.background,
                          items: categories
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c, style: AppTextStyles.body1),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedCategory = v!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: selectedSeason,
                          decoration: InputDecoration(
                            labelText: '계절',
                            fillColor: AppColors.surface,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // 10px
                              borderSide: BorderSide.none,
                            ),
                          ),
                          dropdownColor: AppColors.background,
                          items: seasons
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s, style: AppTextStyles.body1),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => selectedSeason = v!),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // 10px
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text(
                          '취소',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // 10px
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          controller.uploadItem(
                            imageFile,
                            selectedCategory,
                            selectedSeason,
                          );
                        },
                        child: Text('등록하기', style: AppTextStyles.button),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
