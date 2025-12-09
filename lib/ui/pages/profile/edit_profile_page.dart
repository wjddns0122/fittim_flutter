import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_text_field.dart';

class EditProfilePage extends GetView<UserController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Local controllers for text fields
    final heightController = TextEditingController(
      text: controller.height.value,
    );
    final weightController = TextEditingController(
      text: controller.weight.value,
    );

    // Ensure we start with fresh state or current stored value
    // (If using observables directly in text field, we need updates)
    // For simplicity, we bind initial value.

    // Local state for chips (using Rx locally since it's transient form data)
    final initialBodyType =
        {
          'SLIM': '마름',
          'AVERAGE': '보통',
          'CHUBBY': '통통',
          'MUSCULAR': '근육질',
        }[controller.bodyType.value] ??
        '보통';

    final selectedBodyType = initialBodyType.obs;
    final selectedStyles = RxList<String>(controller.preferredStyles);
    final selectedMalls = RxList<String>(controller.preferredMalls);

    final styles = ['미니멀', '스트릿', '꾸안꾸', '페미닌', '캐주얼', '비즈니스', '스포티', '빈티지'];
    final bodyTypes = ['마름', '보통', '통통', '근육질'];
    final malls = ['무신사', '에이블리', '지그재그', '29CM', 'W컨셉', '크림', '유니클로', '자라'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    '프로필 편집',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 24), // Balance spacing
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Scrollable Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image (Placeholder)
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.textHint,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Physical Info
                    const Text(
                      '신체 정보',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextField(
                            hintText: '키 (cm)',
                            controller: heightController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CommonTextField(
                            hintText: '몸무게 (kg)',
                            controller: weightController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Body Type
                    const Text(
                      '체형',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: bodyTypes.map((type) {
                          final isSelected = selectedBodyType.value == type;
                          return ChoiceChip(
                            label: Text(
                              type,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textHint,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) selectedBodyType.value = type;
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppColors.border,
                              ),
                            ),
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Preferred Styles
                    const Text(
                      '선호 스타일',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: styles.map((style) {
                          final isSelected = selectedStyles.contains(style);
                          return FilterChip(
                            label: Text(
                              style,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textHint,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                selectedStyles.add(style);
                              } else {
                                selectedStyles.remove(style);
                              }
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppColors.border,
                              ),
                            ),
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Preferred Malls (New Section)
                    const Text(
                      '선호 쇼핑몰',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: malls.map((mall) {
                          final isSelected = selectedMalls.contains(mall);
                          return FilterChip(
                            label: Text(
                              mall,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textHint,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                selectedMalls.add(mall);
                              } else {
                                selectedMalls.remove(mall);
                              }
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Same styling as styles
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppColors.border,
                              ),
                            ),
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(
                () => CommonButton(
                  text: '저장하기',
                  onPressed: () {
                    // Map Korean display values to API Enum values
                    String apiBodyType = 'AVERAGE';
                    switch (selectedBodyType.value) {
                      case '마름':
                        apiBodyType = 'SLIM';
                        break;
                      case '보통':
                        apiBodyType = 'AVERAGE';
                        break;
                      case '통통':
                        apiBodyType = 'CHUBBY';
                        break;
                      case '근육질':
                        apiBodyType = 'MUSCULAR';
                        break;
                      default:
                        apiBodyType = 'AVERAGE';
                    }

                    controller.updateProfile(
                      heightVal: heightController.text,
                      weightVal: weightController.text,
                      bodyTypeVal: apiBodyType,
                      stylesVal: selectedStyles.toList(),
                      mallsVal: selectedMalls.toList(),
                    );
                  },
                  isLoading: controller.isLoading.value,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
