import 'package:get/get.dart';
import '../../../../data/models/wardrobe_item.dart';

class FitResultController extends GetxController {
  // Observables for UI
  final mainImageUrl = ''.obs;
  final place = ''.obs;
  final mood = ''.obs;
  final season = ''.obs;

  // Items
  final top = Rxn<WardrobeItem>();
  final bottom = Rxn<WardrobeItem>();
  final outer = Rxn<WardrobeItem>();
  final shoes = Rxn<WardrobeItem>();

  // UI State
  final isSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args == null) return;

    try {
      if (args is Map<String, dynamic>) {
        // Case 1: From Generation or generic Map
        // Expected keys: 'top', 'bottom', 'outer', 'shoes', 'place', 'mood', 'season'
        // Items might be JSON maps or WardrobeItem objects

        _parseItem(args['top'], (item) => top.value = item);
        _parseItem(args['bottom'], (item) => bottom.value = item);
        _parseItem(args['outer'], (item) => outer.value = item);
        _parseItem(args['shoes'], (item) => shoes.value = item);

        place.value = args['place']?.toString() ?? '';
        mood.value = args['mood']?.toString() ?? '';
        season.value = args['season']?.toString() ?? '';

        // Determine main image (Outer > Top)
        if (outer.value != null) {
          mainImageUrl.value = outer.value!.imageUrl;
        } else if (top.value != null) {
          mainImageUrl.value = top.value!.imageUrl;
        }
      } else {
        // Case 2: From History (Object)
        // Assuming args is a model with similar fields.
        // using dynamic to handle unknown specific History model class
        final history = args as dynamic;

        // Adapt based on actual History model structure
        // If history has nested objects for items:
        if (_hasField(history, 'top'))
          _parseItem(history.top, (item) => top.value = item);
        if (_hasField(history, 'bottom'))
          _parseItem(history.bottom, (item) => bottom.value = item);
        if (_hasField(history, 'outer'))
          _parseItem(history.outer, (item) => outer.value = item);
        if (_hasField(history, 'shoes'))
          _parseItem(history.shoes, (item) => shoes.value = item);

        place.value = _getField(history, 'place') ?? '';
        mood.value = _getField(history, 'mood') ?? '';
        season.value = _getField(history, 'season') ?? '';

        // Main Image logic
        // If history object has a main image url field
        final historyImg = _getField(history, 'imageUrl');
        if (historyImg != null && historyImg.isNotEmpty) {
          mainImageUrl.value = historyImg;
        } else {
          if (outer.value != null) {
            mainImageUrl.value = outer.value!.imageUrl;
          } else if (top.value != null) {
            mainImageUrl.value = top.value!.imageUrl;
          }
        }
      }
    } catch (e) {
      print('Error parsing arguments: $e');
    }
  }

  // Helper to safely check field existence on dynamic object
  bool _hasField(dynamic object, String fieldName) {
    try {
      // Very basic check, might need reflection or assumes Getters
      // For dynamic/json map access:
      if (object is Map) return object.containsKey(fieldName);
      // For class instance, we can't easily check without reflection or catching NoSuchMethod
      return true; // Optimistic
    } catch (_) {
      return false;
    }
  }

  String? _getField(dynamic object, String fieldName) {
    try {
      if (object is Map) return object[fieldName]?.toString();
      // Assume it's a property access
      // This part is tricky with dynamic on unknown classes in Dart without mirrors
      // So we assume Map or Specific Model.
      // If it's a specific class, we should cast ideally.
      // For now, defaulting to map-like access usually works for JSON parsed data.
      return (object as Map)[fieldName]?.toString();
    } catch (_) {
      return null;
    }
  }

  void _parseItem(dynamic currItem, Function(WardrobeItem) onSet) {
    if (currItem == null) return;
    if (currItem is WardrobeItem) {
      onSet(currItem);
    } else if (currItem is Map<String, dynamic>) {
      onSet(WardrobeItem.fromJson(currItem));
    }
  }

  void toggleSaved() {
    isSaved.value = !isSaved.value;
  }
}
