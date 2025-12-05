import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/register_page.dart';
import 'ui/pages/splash_page.dart';
import 'ui/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FITTIM',
      theme: AppTheme.light, // Applying the global theme
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // Splash handles the initial token check
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(
          name: '/main',
          page: () => const MainPage(),
        ), // Shell with BottomNav
        // Individual pages can still be accessed directly if needed, but usually via Main
        // '/fit-result' is effectively inside /main -> FitPage currently,
        // but we can add it if a standalone result page is needed later.
      ],
    );
  }
}
