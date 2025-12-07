import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../../data/api_provider.dart';
import '../../../../data/models/wardrobe_item.dart';

class FitResultController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Observables for UI
  final mainImageUrl = ''.obs;
  final place = ''.obs;
  final mood = ''.obs;
  final season = ''.obs;
  final reason = ''.obs;
  final fitId = RxnInt(); // To store the ID if available

  // Items
  final generatedItems = <WardrobeItem>[].obs;
  final top = Rxn<WardrobeItem>();
  final bottom = Rxn<WardrobeItem>();
  final outer = Rxn<WardrobeItem>();
  final shoes = Rxn<WardrobeItem>();

  // UI State
  final isSaved = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    print('>>> [DEBUG] Reason Value: ${reason.value}');

    // If we have an ID but no items, fetch details
    if (generatedItems.isEmpty && fitId.value != null) {
      _fetchFitDetail(fitId.value!);
    }
  }

  Future<void> _fetchFitDetail(int id) async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'accessToken');
      if (token == null) return;

      // Ensure endpoint exists or adjust strategy.
      // Assuming REST: GET /api/fits/{id}
      final response = await _apiProvider.dio.get(
        '${ApiProvider.baseUrl}/api/fits/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // Parse the detailed response. It should be a Map like the generation response.
        _parseFromMap(response.data);
      }
    } catch (e) {
      print('Failed to fetch fit details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args == null) return;

    try {
      if (args is Map<String, dynamic>) {
        _parseFromMap(args);
      } else {
        _parseFromHistory(args);
      }
    } catch (e) {
      print('Error parsing arguments: $e');
    }
  }

  void _parseFromMap(Map<String, dynamic> data) {
    print(">>> [DEBUG] Map Parsing Start: $data");

    // Extract ID if present
    if (data['id'] != null) {
      fitId.value = data['id'] is int
          ? data['id']
          : int.tryParse(data['id'].toString());
    }

    final List<WardrobeItem> items = [];

    _parseItem(data['top'], (item) {
      top.value = item;
      items.add(item);
    });
    _parseItem(data['bottom'], (item) {
      bottom.value = item;
      items.add(item);
    });
    _parseItem(data['outer'], (item) {
      outer.value = item;
      items.add(item);
    });
    _parseItem(data['shoes'], (item) {
      shoes.value = item;
      items.add(item);
    });

    generatedItems.assignAll(items);

    place.value = data['place']?.toString() ?? '';
    mood.value = data['mood']?.toString() ?? '';
    season.value = data['season']?.toString() ?? '';
    if (data['reason'] != null) {
      reason.value = data['reason'].toString();
    } else {
      reason.value = "AI가 추천 사유를 생성하지 못했습니다."; // 디버깅용 기본값
    }

    _setMainImage();
  }

  void _parseFromHistory(dynamic history) {
    print(">>> [DEBUG] History Parsing Start");

    // 1. ID Check (Use switch-like helper or try different conventions)
    final idVal = _getField(history, 'id');
    if (idVal != null) {
      fitId.value = int.tryParse(idVal);
    }

    // 2. Map Text Info
    place.value = _getField(history, 'place') ?? '';
    mood.value = _getField(history, 'mood') ?? '';
    season.value = _getField(history, 'season') ?? '';
    reason.value = _getField(history, 'reason') ?? "저장된 추천 사유가 없습니다.";

    // 2. Map Items & Add to List
    final List<WardrobeItem> items = [];

    _parseItemDynamic(history, 'top', (item) {
      top.value = item;
      items.add(item);
    });
    _parseItemDynamic(history, 'bottom', (item) {
      bottom.value = item;
      items.add(item);
    });
    _parseItemDynamic(history, 'outer', (item) {
      outer.value = item;
      items.add(item);
    });
    _parseItemDynamic(history, 'shoes', (item) {
      shoes.value = item;
      items.add(item);
    });

    print(">>> [DEBUG] Extracted Items Count: ${items.length}");

    // 3. Update UI List
    generatedItems.assignAll(items);

    // 4. Set Main Image (Hero)
    // History often has `imageUrl` (composite image). Priority: History.imageUrl > Outer > Top
    final historyImg = _getField(history, 'imageUrl');
    if (historyImg != null && historyImg.isNotEmpty) {
      mainImageUrl.value = historyImg;
    } else if (items.isNotEmpty) {
      // outer is usually index 2 but items aren't ordered by type here strictly, they are added in order of checks.
      // Better to check Observables or find by category/id if needed.
      // logic: Outer > Top (fallback)
      if (outer.value != null) {
        mainImageUrl.value = outer.value!.imageUrl;
      } else if (top.value != null) {
        mainImageUrl.value = top.value!.imageUrl;
      } else {
        mainImageUrl.value = items.first.imageUrl;
      }
    }
  }

  void _parseItemDynamic(
    dynamic parent,
    String field,
    Function(WardrobeItem) onSet,
  ) {
    if (_hasField(parent, field)) {
      try {
        // dynamic access: parent.field -> returns value (Object or Map)
        // Since we don't have Mirrors, we can't do `parent[field]`.
        // We have to hardcode access or use the existing _parseFromDynamic logic of specific checks?
        // Ah, `_parseFromHistory` can't pass 'field' string to access dynamic property directly without Map access.
        // I must manually map fields in the caller.
        // Re-implementing _parseFromHistory caller to do manual property access.
        final itemData = _getFieldObject(parent, field);
        if (itemData != null) {
          _parseItem(itemData, onSet);
        }
      } catch (_) {}
    }
  }

  String? _getField(dynamic object, String fieldName) {
    try {
      // Best effort assumption: it is a Map or has toJson
      if (object is Map) {
        return object[fieldName]?.toString();
      }
      // If it is an Object, try checking standard getters if we knew the type, but we don't.
      // We can only try dynamic access if we hardcode fields or use mirrors (not available).
      // However, the caller used _getField(history, 'place') where history is dynamic.
      // Dynamic access `history.place` works if getter exists.
      // `history[fieldName]` works if it's a Map or has [] operator.
      // Since user said 'FitHistory' object, we likely need `history.place`.
      // BUT I can't write `history.fieldName` dynamically in Dart.
      // So my previous code calling `_getField` with a string key on an Object is flawed unless I switch/case the key.

      // Correct approach for dynamic object field access by string key:
      switch (fieldName) {
        case 'id':
          return object.id?.toString();
        case 'place':
          return object.place?.toString();
        case 'mood':
          return object.mood?.toString();
        case 'season':
          return object.season?.toString();
        case 'reason':
          return object.reason?.toString();
        case 'imageUrl':
          return object.imageUrl?.toString();
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  dynamic _getFieldObject(dynamic object, String fieldName) {
    try {
      if (object is Map) {
        return object[fieldName];
      }
      switch (fieldName) {
        case 'top':
          return object.top;
        case 'bottom':
          return object.bottom;
        case 'outer':
          return object.outer;
        case 'shoes':
          return object.shoes;
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  void _setMainImage() {
    // Default main image logic if specific url not provided
    if (outer.value != null) {
      mainImageUrl.value = outer.value!.imageUrl;
    } else if (top.value != null) {
      mainImageUrl.value = top.value!.imageUrl;
    }
  }

  bool _hasField(dynamic object, String fieldName) {
    // Quick check if we can access the property.
    // In Dart, without mirrors, we can't easily check 'has' on arbitrary objects securely.
    // However, typical pattern for 'dynamic' access usually throws NoSuchMethodError if missing.
    // We'll wrap access in try-catch in the caller or here?
    // Actually, 'd.field' throws if class doesn't have getter.
    // We can't implement 'hasField' easily for Objects without Mirrors.
    // So current approach in _parseFromDynamic simply TRYING to access is safer inside a try block
    // OR we just assume the model structure is consistent.
    // Let's rely on the try-catch block in _parseFromDynamic wrappers or simply access assuming it exists if it's a DTO.
    // But to be safe against "getter not found":
    try {
      // This is a hacky way to check "does this getter exist" by interacting with it? No.
      // Better: Just check if it is not null, but if getter doesn't exist it throws.
      // We will assume the fields exist on the History object as per user description.
      return true;
    } catch (_) {
      return false;
    }
  }

  void _parseItem(dynamic currItem, Function(WardrobeItem) onSet) {
    if (currItem == null) return;
    if (currItem is WardrobeItem) {
      onSet(currItem);
    } else if (currItem is Map<String, dynamic>) {
      try {
        onSet(WardrobeItem.fromJson(currItem));
      } catch (e) {
        print('Error parsing item json: $e');
      }
    }
  }

  void toggleSaved() {
    isSaved.value = !isSaved.value;
  }
}
