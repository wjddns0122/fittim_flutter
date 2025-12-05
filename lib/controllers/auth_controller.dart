import 'dart:convert';
import 'package:fittim_flutter/data/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _storage = const FlutterSecureStorage();
  final RxBool isLoading = false.obs;

  final nameController = TextEditingController(); // For registration

  // Placeholder for API URL - replace with actual env variable or constant
  // API URL from ApiProvider
  static String get _baseUrl => ApiProvider.baseUrl;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        '오류',
        '이메일과 비밀번호를 모두 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print("서버 응답: $decodedBody"); // Debugging

        try {
          final data = jsonDecode(decodedBody);
          final token =
              data['accessToken']; // Updated key based on user request

          if (token != null) {
            await _storage.write(key: 'jwt_token', value: token);
            Get.offAllNamed('/home'); // Navigate to home
          } else {
            _showError('로그인 실패: 토큰이 없습니다.');
          }
        } catch (e) {
          _showError('응답 파싱 오류: $e');
        }
      } else {
        _showError('로그인 실패: ${response.body}');
      }
    } catch (e) {
      _showError('네트워크 오류가 발생했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar('오류', '모든 필드를 입력해주세요.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'nickname': name,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          '성공',
          '회원가입이 완료되었습니다. 로그인해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed('/login'); // Retrieve to login
      } else {
        _showError('회원가입 실패: ${response.body}');
      }
    } catch (e) {
      _showError('네트워크 오류가 발생했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      '오류',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: CupertinoColors.systemRed.withAlpha(
        25,
      ), // 0.1 * 255 approx 25
      colorText: CupertinoColors.systemRed,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
