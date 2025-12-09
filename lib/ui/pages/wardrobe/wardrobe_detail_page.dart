import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/wardrobe_item.dart';
import '../../../controllers/wardrobe_controller.dart';
import '../../../core/theme/app_colors.dart';

class WardrobeDetailPage extends StatelessWidget {
  final WardrobeItem item;

  const WardrobeDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WardrobeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          item.name.isNotEmpty ? item.name : '옷 상세',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Image
              Hero(
                tag: 'wardrobe_${item.id}',
                child: Container(
                  height: 400,
                  width: double.infinity,
                  color: const Color(0xFFF5F5F5),
                  child: Image.network(
                    controller.getFullImageUrl(item.imageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand & Name
                    if (item.brand.isNotEmpty)
                      Text(
                        item.brand,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      item.name.isNotEmpty ? item.name : '이름 없는 아이템',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Details Grid
                    _buildSectionHeader('기본 정보'),
                    const SizedBox(height: 12),
                    _buildInfoRow('카테고리', _getCategoryLabel(item.category)),
                    _buildInfoRow(
                      '계절',
                      item.seasons.isNotEmpty
                          ? item.seasons.map(_getSeasonLabel).join(', ')
                          : _getSeasonLabel(item.season),
                    ),

                    if (item.colors.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSectionHeader('색상'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: item.colors
                            .map(
                              (color) => Chip(
                                label: Text(color),
                                backgroundColor: const Color(0xFFF5F5F5),
                                side: BorderSide.none,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Reuse mapping logic or make it static utility later.
  // For now duplicating minor mapping logic for UI independence unless I move it to Utils.
  String _getCategoryLabel(String code) {
    switch (code) {
      case 'TOP':
        return '상의';
      case 'BOTTOM':
        return '하의';
      case 'OUTER':
        return '아우터';
      case 'DRESS':
        return '원피스';
      case 'SHOES':
        return '신발';
      case 'ACC':
        return '악세사리';
      default:
        return code;
    }
  }

  String _getSeasonLabel(String code) {
    switch (code) {
      case 'SPRING':
        return '봄';
      case 'SUMMER':
        return '여름';
      case 'FALL': // Fallback for various backend namings
      case 'AUTUMN':
        return '가을';
      case 'WINTER':
        return '겨울';
      case 'ALL':
        return '사계절';
      default:
        return code;
    }
  }
}
