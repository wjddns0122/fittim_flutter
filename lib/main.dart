import 'package:fittim_flutter/core/theme/app_theme.dart';
import 'package:fittim_flutter/ui/pages/login_page.dart';
import 'package:fittim_flutter/ui/pages/register_page.dart';
import 'package:fittim_flutter/ui/pages/wardrobe_page.dart';
import 'package:fittim_flutter/ui/pages/fit_page.dart';
import 'package:fittim_flutter/ui/pages/splash_page.dart';
import 'package:fittim_flutter/ui/pages/my_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const FittimApp());
}

class FittimApp extends StatelessWidget {
  const FittimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FITTIM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.materialTheme,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/wardrobe', page: () => const WardrobePage()),
        GetPage(name: '/fit', page: () => const FitPage()),
        GetPage(name: '/mypage', page: () => const MyPage()),
        GetPage(
          name: '/home',
          page: () => Scaffold(
            appBar: AppBar(title: const Text('FITTIM'), centerTitle: true),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/wardrobe'),
                    child: const Text('내 옷장'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/fit'),
                    child: const Text('코디 추천'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/mypage'),
                    child: const Text('마이페이지'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
