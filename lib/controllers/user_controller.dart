import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../data/api_provider.dart';
import '../data/models/user.dart';

class UserController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final ApiProvider _apiProvider = ApiProvider();

  final Rxn<User> user = Rxn<User>();
  final RxBool isLoading = false.obs;

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
      }
    } catch (e) {
      // Error handling
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
