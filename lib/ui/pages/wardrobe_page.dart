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
      appBar: AppBar(
        title: Text('My Wardrobe', style: AppTextStyles.headline2),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Part A: Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: WardrobeController.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = WardrobeController.categories[index];
                return Obx(() {
                  final isSelected = controller.selectedCategory.value == cat;
                  return InkWell(
                    onTap: () => controller.changeCategory(cat),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: AppTextStyles.body2.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          // Part B: Clothes Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (controller.filteredItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.checkroom_outlined,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No items in this category',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  80,
                ), // Bottom padding for FAB
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7, // As requested in Step 3
                ),
                itemCount: controller.filteredItems.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredItems[index];
                  return FashionCard(
                    imageUrl: controller.getFullImageUrl(item.imageUrl),
                    title: item.category,
                    onTap: () {
                      // Detail interactions can go here
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showImageSourceActionSheet(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
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
    // Categories for upload (Korean)
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
                    borderRadius: BorderRadius.circular(12),
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
                              borderRadius: BorderRadius.circular(8),
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
                              borderRadius: BorderRadius.circular(8),
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
                            borderRadius: BorderRadius.circular(8),
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
                            borderRadius: BorderRadius.circular(8),
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
