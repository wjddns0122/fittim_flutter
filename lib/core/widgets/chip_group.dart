import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ChipGroup extends StatelessWidget {
  final String label;
  final List<String> chips;
  final String? selected;
  final ValueChanged<String> onSelect;

  const ChipGroup({
    super.key,
    required this.label,
    required this.chips,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, // text-[12px]
            fontWeight: FontWeight.w300, // font-light
            letterSpacing: 0.6, // tracking-[0.05em] ~ 12 * 0.05
            color: Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 12), // mb-3
        Wrap(
          spacing: 8, // gap-2
          runSpacing: 8,
          children: chips.map((chip) {
            final isSelected = selected == chip;
            return GestureDetector(
              onTap: () => onSelect(chip),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ), // px-5 py-2.5
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFE0E0E0),
                  ),
                  borderRadius: BorderRadius.circular(100), // rounded-full
                ),
                child: Text(
                  chip,
                  style: TextStyle(
                    fontSize: 13, // text-[13px]
                    fontWeight: FontWeight.w300,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
