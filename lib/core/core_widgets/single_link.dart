
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SingleLink extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Alignment alignment;
  final Color? color;

  const SingleLink({
    super.key,
    required this.text,
    required this.onPressed,
    this.alignment = Alignment.centerRight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}