import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../data/models/fit_response.dart';
import '../data/api_provider.dart';

class FitController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  final Rx<FitResponse?> recommendation = Rx<FitResponse?>(null);
  final RxBool isLoading = false.obs;

  // UI State for Inputs
  final RxString selectedSeason = '봄'.obs;
  final RxString selectedPlace = '일상'.obs;

  Future<void> getRecommendation() async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      // Map Strings to Codes
      final seasonMap = {
        '봄': 'SPRING',
        '여름': 'SUMMER',
        '가을': 'AUTUMN',
        '겨울': 'WINTER',
      };

      // Assuming Backend expects Place codes too, defaulting to specific ones or string
      // Spec said: "place (DATE, SCHOOL...)"
      final placeMap = {
        '일상': 'DAILY',
        '데이트': 'DATE',
        '학교': 'SCHOOL',
        '여행': 'TRAVEL',
      };

      final seasonCode = seasonMap[selectedSeason.value] ?? 'SPRING';
      final placeCode = placeMap[selectedPlace.value] ?? 'DAILY';

      final response = await _dio.post(
        '${ApiProvider.baseUrl}/api/fits/recommend',
        data: {'season': seasonCode, 'place': placeCode},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        recommendation.value = FitResponse.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar('알림', '추천을 불러오지 못했습니다. 옷장에 옷이 충분한지 확인해주세요.\n($e)');
      recommendation.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  String getFullImageUrl(String relativePath) {
    if (relativePath.startsWith('http')) return relativePath;
    final baseUrl = ApiProvider.baseUrl;
    if (relativePath.startsWith('/')) {
      return '$baseUrl$relativePath';
    }
    return '$baseUrl/$relativePath';
  }
}
