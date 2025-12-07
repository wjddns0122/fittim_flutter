import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/api_routes.dart';
import '../data/api_provider.dart';
import '../ui/pages/fit/result/fit_result_page.dart';
import '../data/models/fit_response.dart';
import 'fit_controller.dart';

class HomeController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // State
  final userName = 'User'.obs;
  final selectedPlace = '캠퍼스'.obs; // Default
  final selectedMood = '꾸안꾸'.obs; // Default
  late final RxString selectedSeason;
  final fitHistoryList = <dynamic>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedSeason = _getInitialSeason().obs;
    _loadUserName();
    fetchFitHistory();
  }

  String _getInitialSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return '봄';
    if (month >= 6 && month <= 8) return '여름';
    if (month >= 9 && month <= 11) return '가을';
    return '겨울';
  }

  Future<void> _loadUserName() async {
    String? storedName = await _storage.read(key: 'userNickname');
    if (storedName != null && storedName.isNotEmpty) {
      userName.value = storedName;
    } else {
      userName.value = 'User';
    }
  }

  Future<void> fetchFitHistory() async {
    try {
      // isLoading.value = true; // Optional: don't block UI for history
      final token = await _storage.read(key: 'accessToken');
      if (token == null) return;

      final response = await _apiProvider.dio.get(
        '${ApiProvider.baseUrl}/api/fits/history',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        fitHistoryList.value = response.data; // List of objects
      }
    } catch (e) {
      print('Failed to fetch fit history: $e');
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> onCreateFittim() async {
    try {
      final token = await _storage.read(key: 'accessToken');
      if (token == null) return;

      // 1. Show Loading Dialog
      Get.dialog(
        PopScope(
          canPop: false, // Prevent back button
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      "AI 스타일리스트가 옷을 고르고 있어요...",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Call Recommendation API directly
      final response = await _apiProvider.dio.post(
        ApiRoutes.fitRecommend,
        data: {
          'place': _mapPlaceToCode(selectedPlace.value),
          'season': _mapSeasonToEnum(selectedSeason.value),
          // Add mood if supported by backend
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // 2. Close Loading Dialog
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Refresh history immediately so it's ready
        await fetchFitHistory();

        if (Get.isRegistered<FitController>()) {
          try {
            final fitController = Get.find<FitController>();
            fitController.recommendation.value = FitResponse.fromJson(
              responseData,
            );
          } catch (e) {
            print("Sync error: $e");
          }
        }

        // Show Dialog
        Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () {
                Get.back(); // Close dialog
                Get.to(() => const FitResultPage(), arguments: responseData);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  // Fix Overflow
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '오늘의 추천 코디가 도착했어요!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Image Display
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFFF7F7F7),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _buildDialogImage(responseData),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '터치해서 상세 정보 확인하기',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back(); // Close loading if error
      print('Failed to create fittim: $e');
      Get.snackbar('Error', 'Failed to generate fit');
    } finally {
      isLoading.value = false;
    }
  }

  String _mapSeasonToEnum(String seasonName) {
    switch (seasonName) {
      case '봄':
        return 'SPRING';
      case '여름':
        return 'SUMMER';
      case '가을':
        return 'FALL';
      case '겨울':
        return 'WINTER';
      default:
        return 'SPRING';
    }
  }

  String _mapPlaceToCode(String placeName) {
    switch (placeName) {
      case '캠퍼스':
        return 'CAMPUS';
      case '출근':
        return 'WORK';
      case '데이트':
        return 'DATE';
      case '카페':
        return 'CAFE';
      case '집앞':
        return 'HOME';
      default:
        return 'CAMPUS';
    }
  }

  Widget _buildDialogImage(dynamic data) {
    String imageUrl = '';
    if (data is Map<String, dynamic>) {
      // Try Outer then Top
      if (data['outer'] != null && data['outer']['imageUrl'] != null) {
        imageUrl = data['outer']['imageUrl'];
      } else if (data['top'] != null && data['top']['imageUrl'] != null) {
        imageUrl = data['top']['imageUrl'];
      }
    }

    if (imageUrl.isNotEmpty) {
      return Image.network(
        getFullImageUrl(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.checkroom, size: 48, color: Colors.grey),
      );
    }
    return const Icon(Icons.checkroom, size: 48, color: Colors.grey);
  }

  String getFullImageUrl(String relativePath) {
    if (relativePath.startsWith('http')) return relativePath;
    return '${ApiProvider.baseUrl}$relativePath';
  }
}
