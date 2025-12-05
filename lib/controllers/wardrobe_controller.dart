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

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'jwt_token');

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
      // Only show snackbar if not 401 (auth issue handled by flow usually)
      Get.snackbar('오류', '옷장 목록을 불러오는데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Changed from File to XFile to support Web
  Future<void> uploadItem(
    XFile imageFile,
    String category,
    String season,
  ) async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      // Map UI strings to Backend Codes
      final categoryMap = {
        '상의': 'TOP',
        '하의': 'BOTTOM',
        '아우터': 'OUTER',
        '원피스': 'DRESS',
        '신발': 'SHOES',
        '가방': 'BAG',
        '기타': 'ETC',
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

      print('전송 데이터: $categoryCode, $seasonCode');

      // Use fromBytes for Web compatibility
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
        Get.back(); // Close dialog if open
        Get.snackbar('성공', '옷이 등록되었습니다.');
        fetchItems(); // Refresh list
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

    // Ensure correct slashing
    if (relativePath.startsWith('/')) {
      return '$baseUrl$relativePath';
    }
    return '$baseUrl/$relativePath';
  }
}
