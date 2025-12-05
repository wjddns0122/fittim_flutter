import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/api_provider.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); // Nickname

  final isLoading = false.obs;
  final storage = const FlutterSecureStorage();

  // Added for Password Toggle
  final isPasswordVisible = false.obs;
  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('${ApiProvider.baseUrl}/api/auth/login'), // Fixed Path
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['accessToken'];
        await storage.write(key: 'accessToken', value: token);
        Get.offAllNamed('/main');
      } else {
        Get.snackbar(
          'Login Failed',
          'Check your credentials (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('${ApiProvider.baseUrl}/api/auth/signup'), // Fixed Path
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
          'nickname': nameController.text,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Account created! Please login.');
        Get.offNamed('/login');
      } else {
        Get.snackbar('Register Failed', 'Error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
