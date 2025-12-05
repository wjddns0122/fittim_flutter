import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FashionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const FashionCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Container - Visual Clone of ClothingItemCard.tsx
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface, // #F7F7F7
              borderRadius: BorderRadius.circular(16), // rounded-2xl
              border: Border.all(color: AppColors.border), // #F0F0F0
              // image loading/error handled by NetworkImage usually
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.textHint,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10), // mb-2.5
        // Label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4), // px-1
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
