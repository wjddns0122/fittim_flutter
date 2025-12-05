import 'package:fittim_flutter/core/theme/app_theme.dart';
import 'package:fittim_flutter/ui/pages/login_page.dart';
import 'package:fittim_flutter/ui/pages/register_page.dart';
import 'package:fittim_flutter/ui/pages/wardrobe_page.dart';
import 'package:fittim_flutter/ui/pages/fit_page.dart';
import 'package:flutter/cupertino.dart';
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
      initialRoute: '/login', // Set initial route to Login for now
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/wardrobe', page: () => const WardrobePage()),
        GetPage(name: '/fit', page: () => const FitPage()),
        GetPage(
          name: '/home',
          page: () => const CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(middle: Text('FITTIM')),
            child: Center(child: Text('Home Screen')),
          ),
        ),
      ],
    );
  }
}
