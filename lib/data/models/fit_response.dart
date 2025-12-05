import 'wardrobe_item.dart';

class FitResponse {
  final WardrobeItem? top;
  final WardrobeItem? bottom;
  final WardrobeItem? outer;

  FitResponse({this.top, this.bottom, this.outer});

  factory FitResponse.fromJson(Map<String, dynamic> json) {
    return FitResponse(
      top: json['top'] != null ? WardrobeItem.fromJson(json['top']) : null,
      bottom: json['bottom'] != null
          ? WardrobeItem.fromJson(json['bottom'])
          : null,
      outer: json['outer'] != null
          ? WardrobeItem.fromJson(json['outer'])
          : null,
    );
  }
}
