import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check for accessToken (consistent with AuthController)
    final token = await _storage.read(key: 'accessToken');

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed('/main'); // Navigate to Main Shell
    } else {
      Get.offAllNamed('/login');
    }
  }
}
