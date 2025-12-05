import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const InfoCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ), // p-4 ~ 16
      decoration: BoxDecoration(
        color: AppColors.surface, // #F7F7F7
        borderRadius: BorderRadius.circular(16), // rounded-2xl
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8), // mb-2
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
