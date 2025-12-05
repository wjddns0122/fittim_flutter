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
        Text(
          label,
          style: const TextStyle(
            fontSize:
                16, // Assuming similar to React defaults or slight increase for better mobile read
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips.map((chip) {
            final isSelected = selected == chip;
            return GestureDetector(
              onTap: () => onSelect(chip),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A1A1A)
                      : Colors.white, // Selected Black, Unselected White
                  borderRadius: BorderRadius.circular(100), // Rounded Full
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFEAEAEA),
                  ),
                ),
                child: Text(
                  chip,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
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
