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
          // Image Section (Aspect Square 1:1)
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface, // #F7F7F7
                borderRadius: BorderRadius.circular(16), // rounded-2xl
                border: Border.all(
                  color: AppColors.surfaceBorder,
                  width: 1,
                ), // border-[#F0F0F0]
                boxShadow: const [
                  BoxShadow(
                    color: Color(
                      0x0D000000,
                    ), // Colors.black with ~5% opacity (0.05 * 255 ≈ 13 -> 0D)
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.checkroom,
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
            const SizedBox(height: 10), // mb-2.5 is approx 10px
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4), // px-1
              child: Text(
                title!,
                style: AppTextStyles.body2.copyWith(
                  fontSize: 13, // text-[13px]
                  fontWeight: FontWeight.w300, // font-light
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
