import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../../data/api_provider.dart';
import '../../../../data/models/wardrobe_item.dart';

class FitResultController extends GetxController {
  final ApiProvider _apiProvider;
  final FlutterSecureStorage _storage;

  FitResultController({ApiProvider? apiProvider, FlutterSecureStorage? storage})
    : _apiProvider = apiProvider ?? ApiProvider(),
      _storage = storage ?? const FlutterSecureStorage();

  // #region Observables
  final mainImageUrl = ''.obs;
  final place = ''.obs;
  final mood = ''.obs;
  final season = ''.obs;
  final reason = ''.obs;
  final fitId = RxnInt();

  // Items
  final generatedItems = <WardrobeItem>[].obs;
  final top = Rxn<WardrobeItem>();
  final bottom = Rxn<WardrobeItem>();
  final outer = Rxn<WardrobeItem>();
  final shoes = Rxn<WardrobeItem>();

  // UI State
  final isSaved = false.obs;
  final isLoading = false.obs;
  // #endregion

  // #region Lifecycle
  @override
  void onInit() {
    super.onInit();
    initData(Get.arguments);
  }

  void initData(dynamic args) {
    debugPrint('>>> [FitResultController] Init Args: $args');
    _parseArguments(args);

    // Fetch details if items are missing OR if reason is missing/default
    bool missingReason =
        reason.value.isEmpty ||
        reason.value == "저장된 추천 사유가 없습니다." ||
        reason.value == "AI가 추천 사유를 생성하지 못했습니다.";

    debugPrint(
      '>>> [FitResultController] Missing Reason? $missingReason (Current: ${reason.value})',
    );

    if ((generatedItems.isEmpty || missingReason) && fitId.value != null) {
      debugPrint(
        '>>> [FitResultController] Fetching details for ID: ${fitId.value}',
      );
      _fetchFitDetail(fitId.value!);
    }
  }
  // #endregion

  // #region API Methods
  Future<void> _fetchFitDetail(int id) async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'accessToken');
      if (token == null) return;

      final response = await _apiProvider.dio.get(
        '${ApiProvider.baseUrl}/api/fits/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('>>> [FitResultController] Detail Response: ${response.data}');

      if (response.statusCode == 200) {
        _parseFromMap(response.data);
      }
    } catch (e) {
      debugPrint('Failed to fetch fit details: $e');
    } finally {
      isLoading.value = false;
    }
  }
  // #endregion

  // #region Parsing Logic
  void _parseArguments(dynamic args) {
    if (args == null) return;

    try {
      if (args is Map<String, dynamic>) {
        _parseFromMap(args);
      } else {
        _parseFromHistory(args);
      }
    } catch (e) {
      debugPrint('Error parsing arguments: $e');
    }
  }

  void _parseFromMap(Map<String, dynamic> data) {
    debugPrint('>>> [FitResultController] Parsing from Map: $data');
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
    reason.value = data['reason']?.toString() ?? "AI가 추천 사유를 생성하지 못했습니다.";

    debugPrint(
      '>>> [FitResultController] Reason after map parse: ${reason.value}',
    );

    _setMainImage();
  }

  void _parseFromHistory(dynamic history) {
    debugPrint('>>> [FitResultController] History Data: $history');

    final idVal = _getField(history, 'id');
    if (idVal != null) {
      fitId.value = int.tryParse(idVal);
    }

    place.value = _getField(history, 'place') ?? '';
    mood.value = _getField(history, 'mood') ?? '';
    season.value = _getField(history, 'season') ?? '';
    reason.value = _getField(history, 'reason') ?? "저장된 추천 사유가 없습니다.";

    debugPrint(
      '>>> [FitResultController] Reason parsed from history: ${reason.value}',
    );

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

    generatedItems.assignAll(items);

    // Map Images
    final historyImg = _getField(history, 'imageUrl');
    if (historyImg != null && historyImg.isNotEmpty) {
      mainImageUrl.value = historyImg;
    } else if (items.isNotEmpty) {
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
        final itemData = _getFieldObject(parent, field);
        if (itemData != null) {
          _parseItem(itemData, onSet);
        }
      } catch (_) {}
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
        debugPrint('Error parsing item json: $e');
      }
    }
  }
  // #endregion

  // #region Helpers
  String? _getField(dynamic object, String fieldName) {
    try {
      if (object is Map) {
        final val = object[fieldName]?.toString();
        debugPrint('>>> [FitResultController] _getField(Map) $fieldName: $val');
        return val;
      }
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
          final val = object.reason?.toString();
          debugPrint(
            '>>> [FitResultController] _getField(Object) reason: $val',
          );
          return val;
        case 'imageUrl':
          return object.imageUrl?.toString();
        default:
          return null;
      }
    } catch (e) {
      debugPrint('>>> [FitResultController] _getField Error ($fieldName): $e');
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
    if (outer.value != null) {
      mainImageUrl.value = outer.value!.imageUrl;
    } else if (top.value != null) {
      mainImageUrl.value = top.value!.imageUrl;
    }
  }

  bool _hasField(dynamic object, String fieldName) {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  void toggleSaved() {
    isSaved.value = !isSaved.value;
  }

  // #endregion
}
