import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../data/api_provider.dart';
import '../data/models/user.dart';

class UserController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final ApiProvider _apiProvider = ApiProvider();

  final Rxn<User> user = Rxn<User>();
  final RxBool isLoading = false.obs;

  // Profile Edit Observables
  final height = ''.obs;
  final weight = ''.obs;
  final bodyType = ''.obs;
  final preferredStyles = <String>[].obs;
  final preferredMalls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // fetchProfile uses ApiProvider which handles token automatically, so no need for explicit check here that might bounce
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.dio.get('/api/users/me');

      if (response.statusCode == 200) {
        final data = response.data;
        user.value = User(
          nickname: data['nickname'] ?? 'User',
          email: data['email'] ?? '',
        );
        // Initialize profile edit observables with fetched data if available
        height.value = data['height']?.toString() ?? '';
        weight.value = data['weight']?.toString() ?? '';
        bodyType.value = data['bodyType'] ?? '';
        preferredStyles.value = List<String>.from(
          data['preferredStyles'] ?? [],
        );
        preferredMalls.value = List<String>.from(data['preferredMalls'] ?? []);
      }
    } catch (e) {
      debugPrint('Failed to fetch user profile: $e');
      // Error handling
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String heightVal,
    required String weightVal,
    required String bodyTypeVal,
    required List<String> stylesVal,
    required List<String> mallsVal,
  }) async {
    try {
      isLoading.value = true;
      final data = {
        'height': double.tryParse(heightVal),
        'weight': double.tryParse(weightVal),
        'bodyType': bodyTypeVal,
        'preferredStyles': stylesVal,
        'preferredMalls': mallsVal,
      };

      final response = await _apiProvider.dio.patch(
        '/api/users/me',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Update local state
        height.value = heightVal;
        weight.value = weightVal;
        bodyType.value = bodyTypeVal;
        preferredStyles.value = stylesVal;
        preferredMalls.value = mallsVal;

        Get.back(); // Return to MyPage first

        Get.snackbar(
          '성공',
          '프로필이 성공적으로 업데이트되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );
      } else {
        // Handle other status codes
        Get.snackbar(
          '실패',
          '업데이트에 실패했습니다. (Status: ${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Failed to update profile: $e');
      Get.snackbar(
        '오류',
        '프로필 업데이트에 실패했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    // Clean up all possible keys
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'accessToken');
    Get.offAllNamed('/login');
  }
}
