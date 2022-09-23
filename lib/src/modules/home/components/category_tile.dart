import 'package:flutter/material.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';

class CategoryTile extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryTile({
    Key? key,
    required this.category,
    this.isSelected = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? CustomColors.customSwatchColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : CustomColors.customContrastColor,
              fontWeight: FontWeight.bold,
              fontSize: isSelected ? 17 : 16,
            ),
          ),
        ),
      ),
    );
  }
}
