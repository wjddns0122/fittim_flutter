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
      backgroundColor: AppColors.background,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            // Home Tab PlaceHolder (React: Home Icon)
            Center(child: Text("Home - Coming Soon")),

            // Fit Tab (React: Sparkles Icon)
            FitPage(),

            // Wardrobe Tab (React: ShoppingBag Icon)
            WardrobePage(),

            // Shop Tab Placeholder (React: Store Icon)
            Center(child: Text("Shop - Coming Soon")),

            // My Tab (React: User Icon)
            MyPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFEAEAEA), // border-t border-[#EAEAEA]
              width: 1,
            ),
          ),
        ),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            type: BottomNavigationBarType.fixed, // Ensure all items show
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF1A1A1A), // text-[#1A1A1A]
            unselectedItemColor: const Color(0xFF9C9C9C), // text-[#9C9C9C]
            selectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), // Lucide: Home
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.auto_awesome_outlined,
                ), // Lucide: Sparkles (Fit)
                activeIcon: Icon(Icons.auto_awesome),
                label: 'Fit',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.checkroom_outlined,
                ), // Lucide: ShoppingBag (Wardrobe) (Approx)
                activeIcon: Icon(Icons.checkroom),
                label: 'Wardrobe',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined), // Lucide: Store
                activeIcon: Icon(Icons.storefront),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), // Lucide: User
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
