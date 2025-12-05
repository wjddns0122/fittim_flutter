import 'package:dio/dio.dart';
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
    selectedCategory.value = category;
  }

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      // Fixed: Check 'accessToken'
      final token = await _storage.read(key: 'accessToken');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await _dio.get(
        '${ApiProvider.baseUrl}/api/wardrobe',
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

  Future<void> uploadItem(
    XFile imageFile,
    String category,
    String season,
  ) async {
    try {
      isLoading.value = true;
      // Fixed: Check 'accessToken'
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
        '가을': 'AUTUMN',
        '겨울': 'WINTER',
        '사계절': 'ALL',
      };

      final categoryCode = categoryMap[category] ?? 'ETC';
      final seasonCode = seasonMap[season] ?? 'ALL';

      final bytes = await imageFile.readAsBytes();
      final String fileName = imageFile.name;

      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(bytes, filename: fileName),
        'category': categoryCode,
        'season': seasonCode,
      });

      final response = await _dio.post(
        '${ApiProvider.baseUrl}/api/wardrobe',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
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
