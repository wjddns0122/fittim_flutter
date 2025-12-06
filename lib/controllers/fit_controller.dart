import 'package:get/get.dart';
import '../data/models/fit_response.dart';
import '../data/api_provider.dart';
import '../core/constants/api_routes.dart';

class FitController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final selectedSeason = '봄'.obs;
  final selectedPlace = '데이트'.obs;

  final recommendation = Rxn<FitResponse>();
  final isLoading = false.obs;

  List<String> getTags() {
    return ['#${selectedSeason.value}', '#${selectedPlace.value}'];
  }

  String getFullImageUrl(String? path) {
    if (path == null) return '';
    if (path.startsWith('http')) return path;
    return '${ApiProvider.baseUrl}/$path';
  }

  Future<void> getRecommendation() async {
    try {
      isLoading.value = true;

      String seasonCode = _mapSeasonToCode(selectedSeason.value);
      String placeCode = _mapPlaceToCode(selectedPlace.value);

      final response = await _apiProvider.dio.post(
        ApiRoutes.fitRecommend,
        data: {'season': seasonCode, 'place': placeCode},
      );

      if (response.statusCode == 200) {
        recommendation.value = FitResponse.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get recommendation: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void saveLook() {
    Get.snackbar('Saved', 'Outfit saved to your lookbook');
  }

  void clearRecommendation() {
    recommendation.value = null;
  }

  String _mapSeasonToCode(String season) {
    switch (season) {
      case '봄':
        return 'SPRING';
      case '여름':
        return 'SUMMER';
      case '가을':
        return 'AUTUMN';
      case '겨울':
        return 'WINTER';
      default:
        return 'SPRING';
    }
  }

  String _mapPlaceToCode(String place) {
    switch (place) {
      case '데이트':
        return 'DATE';
      case '출근':
        return 'WORK';
      case '학교':
        return 'SCHOOL';
      case '여행':
        return 'TRAVEL';
      case '파티':
        return 'PARTY';
      case '카페':
        return 'CAFE';
      case '결혼식':
        return 'WEDDING';
      default:
        return 'DAILY';
    }
  }
}
