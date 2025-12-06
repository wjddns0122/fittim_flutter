import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/signup_page.dart';
import 'ui/pages/splash_page.dart';
import 'ui/pages/main_page.dart';
import 'ui/pages/wardrobe_page.dart';
import 'ui/pages/fit_page.dart';
import 'controllers/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FITTIM',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: BindingsBuilder(() {
            Get.put(AuthController());
          }),
        ),
        GetPage(
          name: '/register',
          page: () => const SignupPage(),
        ), // Changed to SignupPage
        GetPage(name: '/main', page: () => const MainPage()),
        GetPage(name: '/wardrobe', page: () => const WardrobePage()),
        GetPage(name: '/fit', page: () => const FitPage()),
      ],
    );
  }
}
