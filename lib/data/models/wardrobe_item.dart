class WardrobeItem {
  final int id;
  final String imageUrl;
  final String category;
  final String season;

  WardrobeItem({
    required this.id,
    required this.imageUrl,
    required this.category,
    required this.season,
  });

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      season: json['season'] as String,
    );
  }
}
