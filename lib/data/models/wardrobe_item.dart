class WardrobeItem {
  final int id;
  final String imageUrl;
  final String category;
  final String season;
  final String name;
  final String brand;
  final List<String> colors;
  final List<String> seasons;

  WardrobeItem({
    required this.id,
    required this.imageUrl,
    required this.category,
    required this.season,
    this.name = '',
    this.brand = '',
    this.colors = const [],
    this.seasons = const [],
  });

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      season: json['season'] as String? ?? 'ALL', // Handle null if needed
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      colors: (json['colors'] as List?)?.map((e) => e as String).toList() ?? [],
      seasons:
          (json['seasons'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }
}
