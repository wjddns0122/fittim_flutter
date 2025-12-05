import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../data/api_provider.dart';

class UserController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  final RxString nickname = ''.obs;
  final RxString email = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await _dio.get(
        '${ApiProvider.baseUrl}/api/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Assuming response structure: { "email": "...", "nickname": "..." }
        // Adjust if backend model differs
        nickname.value = data['nickname'] ?? 'User';
        email.value = data['email'] ?? '';
      }
    } catch (e) {
      Get.snackbar('오류', '프로필을 불러오는데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    Get.offAllNamed('/login');
  }
}
