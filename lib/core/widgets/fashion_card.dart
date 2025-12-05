import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FashionCard extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final VoidCallback? onTap;

  const FashionCard({
    super.key,
    required this.imageUrl,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Section
          Expanded(
            // Changed from AspectRatio to Expanded to fill available space in Grid
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface, // Placeholder background
                borderRadius: BorderRadius.circular(
                  12,
                ), // Slightly softer than inputs
                boxShadow: const [
                  BoxShadow(
                    color: Color(
                      0x0A000000,
                    ), // Very subtle shadow (opacity ~4%)
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.checkroom, // Fallback icon
                        color: AppColors.textHint,
                        size: 32,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textHint,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Title Section
          if (title != null) ...[
            const SizedBox(height: 8),
            Text(
              title!,
              style: AppTextStyles.body2.copyWith(
                // 14px for cards
                fontWeight: FontWeight.w500, // Medium for readability
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
