import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/wardrobe_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WardrobePage extends GetView<WardrobeController> {
  const WardrobePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WardrobeController>()) {
      Get.put(WardrobeController());
    }

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundPrimary,
      navigationBar: const CupertinoNavigationBar(middle: Text('내 옷장')),
      child: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const Center(child: CupertinoActivityIndicator());
              }

              if (controller.items.isEmpty) {
                return Center(
                  child: Text(
                    '옷장이 비어있습니다.\n+ 버튼을 눌러 옷을 등록해보세요.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          controller.getFullImageUrl(item.imageUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: AppColors.backgroundSecondary,
                                child: const Icon(
                                  CupertinoIcons.photo_on_rectangle,
                                  color: AppColors.textHint,
                                ),
                              ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withAlpha(102), // 0.4 opacity
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              item.category,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.tiny.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),

            // FAB
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.buttonPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51), // 0.2 opacity
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('옷 등록하기'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Get.back(); // Close sheet
              _pickImage(ImageSource.camera);
            },
            child: const Text('카메라로 촬영'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Get.back(); // Close sheet
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
        backgroundColor: AppColors.backgroundPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('상세 정보 입력', style: AppTextStyles.titleMedium),
                const SizedBox(height: 20),

                // Image Preview (Web Compatible)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: kIsWeb
                        ? Image.network(imageFile.path, fit: BoxFit.cover)
                        : Image.file(File(imageFile.path), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),

                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: selectedCategory,
                          decoration: const InputDecoration(labelText: '카테고리'),
                          items: categories
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedCategory = v!),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: selectedSeason,
                          decoration: const InputDecoration(labelText: '계절'),
                          items: seasons
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => selectedSeason = v!),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        '취소',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        controller.uploadItem(
                          imageFile,
                          selectedCategory,
                          selectedSeason,
                        );
                      },
                      child: const Text(
                        '등록',
                        style: TextStyle(color: Colors.white),
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
