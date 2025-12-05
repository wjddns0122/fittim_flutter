import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/main_controller.dart';
import '../../core/theme/app_colors.dart';
import 'wardrobe_page.dart';
import 'fit_page.dart';
import 'my_page.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered if not already
    // (Though usually done via binding or Get.put at route level)
    if (!Get.isRegistered<MainController>()) {
      Get.put(MainController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [WardrobePage(), FitPage(), MyPage()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            backgroundColor: AppColors.background,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textHint,
            showSelectedLabels: false, // Minimal style as requested
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.checkroom),
                label: 'Wardrobe',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.style), // or auto_awesome_mosaic
                label: 'Fit',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
            ],
          ),
        ),
      ),
    );
  }
}
