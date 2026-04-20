// lib/features/worksspace/presentation/widgets/workspace_widgets/color_dot.dart

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorDot({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppValues.animFast,
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: AppColors.white, width: 2.5)
              : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.55), blurRadius: 7)]
              : [],
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: AppColors.white, size: 13)
            : null,
      ),
    );
  }
}