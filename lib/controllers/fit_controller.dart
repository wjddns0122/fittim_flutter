import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../data/api_provider.dart';
import '../data/models/fit_response.dart';

class FitController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  final RxBool isLoading = false.obs;
  final Rxn<FitResponse> recommendation = Rxn<FitResponse>();

  // Use these to display context in UI
  final RxString selectedSeason = '봄'.obs;
  final RxString selectedPlace = '데이트'.obs;

  Future<void> getRecommendation() async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final seasonMap = {
        '봄': 'SPRING',
        '여름': 'SUMMER',
        '가을': 'AUTUMN',
        '겨울': 'WINTER',
        '사계절': 'ALL',
      };

      final placeMap = {
        '데이트': 'DATE',
        '학교': 'SCHOOL',
        '여행': 'TRAVEL',
        '파티': 'PARTY',
      };

      final seasonCode = seasonMap[selectedSeason.value] ?? 'SPRING';
      final placeCode = placeMap[selectedPlace.value] ?? 'DATE';

      // Added placeCode to queryParameters
      final response = await _dio.get(
        '${ApiProvider.baseUrl}/api/recommendations',
        queryParameters: {'season': seasonCode, 'place': placeCode},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        recommendation.value = FitResponse.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar('오류', '추천을 받아오지 못했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void saveLook() {
    Get.snackbar(
      '저장 완료',
      '나만의 코디북에 저장되었습니다.',
      duration: const Duration(seconds: 1),
    );
  }

  String getFullImageUrl(String? relativePath) {
    if (relativePath == null) return '';
    if (relativePath.startsWith('http')) return relativePath;
    final baseUrl = ApiProvider.baseUrl;
    if (relativePath.startsWith('/')) {
      return '$baseUrl$relativePath';
    }
    return '$baseUrl/$relativePath';
  }
}
