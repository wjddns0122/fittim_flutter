import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/wardrobe_controller.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import '../../../core/widgets/common_button.dart';
import '../../../core/widgets/common_text_field.dart';

class AddClothingPage extends StatefulWidget {
  final XFile imageFile;

  const AddClothingPage({super.key, required this.imageFile});

  @override
  State<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  final WardrobeController controller = Get.find<WardrobeController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();

  final RxString selectedCategory = '상의'.obs;
  // Multi-select for colors and seasons
  final RxList<String> selectedColors = <String>[].obs;
  final RxList<String> selectedSeasons = <String>[].obs;

  final List<String> categories = [
    '상의',
    '하의',
    '아우터',
    '원피스',
    '신발',
    '가방',
    '악세사리',
  ];
  final List<String> seasons = ['봄', '여름', '가을', '겨울'];
  final List<String> colors = [
    '블랙',
    '화이트',
    '그레이',
    '네이비',
    '베이지',
    '브라운',
    '레드',
    '오렌지',
    '옐로우',
    '카키',
    '블루',
    '퍼플',
    '핑크',
    '실버',
    '골드',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('새 옷 등록', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: kIsWeb
                      ? Image.network(
                          widget.imageFile.path,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.imageFile.path),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // Name
              const Text(
                '이름',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              CommonTextField(
                hintText: '예: 흰색 기본 티셔츠',
                controller: nameController,
              ),
              const SizedBox(height: 24),

              // Brand
              const Text(
                '브랜드',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              CommonTextField(
                hintText: '예: 나이키, 보세',
                controller: brandController,
              ),
              const SizedBox(height: 24),

              // Category
              const Text(
                '카테고리',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  return Obx(() {
                    final isSelected = selectedCategory.value == cat;
                    return ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) selectedCategory.value = cat;
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.border,
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Seasons (Multi-select)
              const Text(
                '계절',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: seasons.map((season) {
                  return Obx(() {
                    final isSelected = selectedSeasons.contains(season);
                    return FilterChip(
                      label: Text(
                        season,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          selectedSeasons.add(season);
                        } else {
                          selectedSeasons.remove(season);
                        }
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.border,
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Colors (Multi-select)
              const Text(
                '색상',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colors.map((color) {
                  return Obx(() {
                    final isSelected = selectedColors.contains(color);
                    return FilterChip(
                      label: Text(
                        color,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          selectedColors.add(color);
                        } else {
                          selectedColors.remove(color);
                        }
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.border,
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
              const SizedBox(height: 48),

              // Submit Button
              Obx(
                () => CommonButton(
                  text: '등록하기',
                  onPressed: () {
                    controller.uploadItem(
                      imageFile: widget.imageFile,
                      name: nameController.text,
                      brand: brandController.text,
                      category: selectedCategory.value,
                      seasons: selectedSeasons.toList(),
                      colors: selectedColors.toList(),
                    );
                  },
                  isLoading: controller.isLoading.value,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
