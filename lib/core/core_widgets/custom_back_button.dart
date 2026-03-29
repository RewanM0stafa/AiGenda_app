import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// تأكدي من مسار الـ import الخاص بملف الألوان عندك
import '../constants/app_colors.dart';


class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  const CustomBackButton({
    super.key,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.pop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.cardBorder, // استخدام اللون من الـ Constant class
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: iconColor ?? AppColors.primary, // اللون الأساسي للتطبيق
          size: 18,
        ),
      ),
    );
  }
}