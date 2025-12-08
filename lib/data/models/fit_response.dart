import 'wardrobe_item.dart';

class FitResponse {
  final int? id;
  final String? place;
  final String? mood;
  final String? season;
  final String? reason;
  final String? imageUrl;
  final WardrobeItem? top;
  final WardrobeItem? bottom;
  final WardrobeItem? outer;

  FitResponse({
    this.id,
    this.place,
    this.mood,
    this.season,
    this.reason,
    this.imageUrl,
    this.top,
    this.bottom,
    this.outer,
  });

  factory FitResponse.fromJson(Map<String, dynamic> json) {
    return FitResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      place: json['place']?.toString(),
      mood: json['mood']?.toString(),
      season: json['season']?.toString(),
      reason: json['reason']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
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
