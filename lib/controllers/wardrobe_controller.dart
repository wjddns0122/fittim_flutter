import 'package:dio/dio.dart';
import '../core/constants/api_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import '../data/models/wardrobe_item.dart';
import '../data/api_provider.dart';

class WardrobeController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final _picker = ImagePicker();
  final Dio _dio = Dio();

  final RxList<WardrobeItem> items = <WardrobeItem>[].obs;
  final RxBool isLoading = false.obs;

  // Category Filtering Logic
  final RxString selectedCategory = 'ALL'.obs;

  static const List<String> categories = [
    'ALL',
    'TOP',
    'BOTTOM',
    'OUTER',
    'SHOES',
    'ACC',
  ];

  List<WardrobeItem> get filteredItems {
    if (selectedCategory.value == 'ALL') {
      return items;
    }
    return items
        .where((item) => item.category == selectedCategory.value)
        .toList();
  }

  void changeCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    fetchItems();
  }

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'accessToken');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final queryParams = <String, dynamic>{};
      if (selectedCategory.value != 'ALL') {
        queryParams['category'] = selectedCategory.value;
      }

      final response = await _dio.get(
        '${ApiProvider.baseUrl}${ApiRoutes.wardrobe}',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        items.value = data.map((e) => WardrobeItem.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('오류', '옷장 목록을 불러오는데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadItem({
    required XFile imageFile,
    required String name,
    required String brand,
    required String category,
    required List<String> seasons,
    required List<String> colors,
  }) async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'accessToken');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final categoryMap = {
        '상의': 'TOP',
        '하의': 'BOTTOM',
        '아우터': 'OUTER',
        '원피스': 'DRESS',
        '신발': 'SHOES',
        '가방': 'ACC',
        '기타': 'ACC',
        '악세사리': 'ACC',
      };

      final seasonMap = {
        '봄': 'SPRING',
        '여름': 'SUMMER',
        '가을': 'FALL',
        '겨울': 'WINTER',
        '사계절': 'ALL',
      };

      final categoryCode = categoryMap[category] ?? 'ETC';
      final seasonCodes = seasons.map((s) => seasonMap[s] ?? 'ALL').toList();
      final String legacySeason = seasonCodes.isNotEmpty
          ? seasonCodes.first
          : 'ALL';

      final bytes = await imageFile.readAsBytes();
      final String fileName = imageFile.name;

      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(bytes, filename: fileName),
        'category': categoryCode,
        'season': legacySeason, // Legacy field
        'name': name,
        'brand': brand,
        'seasons': seasonCodes,
        'colors': colors,
      });

      final response = await _dio.post(
        '${ApiProvider.baseUrl}${ApiRoutes.wardrobe}',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close AddClothingPage
        Get.snackbar('성공', '옷이 등록되었습니다.');

        await fetchItems();

        if (categories.contains(categoryCode)) {
          selectedCategory.value = categoryCode;
        } else {
          selectedCategory.value = 'ALL';
        }
      }
    } catch (e) {
      Get.snackbar('오류', '업로드 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<XFile?> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    return pickedFile;
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
