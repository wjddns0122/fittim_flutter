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
    if (!Get.isRegistered<MainController>()) {
      Get.put(MainController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            // 0: Home
            FitPage(isHomeMode: true), // Reusing FitPage for Home/Input mode
            // 1: Fit (Result?) - React App.tsx maps 'results' to OutfitResultsScreen
            // But logic-wise, Home generates Fit. So 'Fit' tab could be history or active result.
            // For now, let's make Fit tab also show FitPage or a placeholder if logic is shared.
            // React App.tsx has 'Home' and 'Fit' (Sparkles) and 'Wardrobe' etc.
            // Usually 'Fit' tab might be the Result View or History.
            // I'll point it to FitPage but maybe with a different initial state if possible, or duplicates for now.
            FitPage(
              isHomeMode: false,
            ), // Assuming this forces a different view or just same page
            // 2: Wardrobe
            WardrobePage(),

            // 3: Shop
            Center(child: Text("Shop - Coming Soon")),

            // 4: My
            MyPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.border, // #F0F0F0 or #EAEAEA from React
              width: 1,
            ),
          ),
        ),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary, // #1A1A1A
            unselectedItemColor: AppColors.textSecondary, // #9C9C9C
            selectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              fontFamily: 'Inter',
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              fontFamily: 'Inter',
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome_outlined),
                activeIcon: Icon(Icons.auto_awesome),
                label: 'Fit',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                ), // React uses ShoppingBag for Wardrobe
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Wardrobe',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined),
                activeIcon: Icon(Icons.storefront),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'My',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
