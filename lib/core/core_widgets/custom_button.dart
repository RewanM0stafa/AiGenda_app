
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutline;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutline = false,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // لو isLoading بـ true، نمنع الضغط عن طريق تمرير null
      onTap: (isLoading || onPressed == null) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width ?? double.infinity,
        height: AppValues.buttonHeight,
        decoration: _buildDecoration(),
        alignment: Alignment.center,
        child: isLoading
            ? _buildLoadingIndicator()
            : Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            // لو Outline نخلي النص باللون الأساسي، لو Filled نخليه أبيض
            color: isOutline ? AppColors.primary : AppColors.white,
          ),
        ),
      ),
    );
  }

  // ميثود مساعدة لتنظيم الكود (Decoration)
  BoxDecoration _buildDecoration() {
    if (isOutline) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        color: AppColors.white, // خلفية بيضاء للـ Outline
        border: Border.all(color: AppColors.primary, width: 1.5),
      );
    }

    return BoxDecoration(
      gradient: isLoading ? null : AppColors.primaryGradient,
      color: isLoading ? AppColors.grey : null, // لون باهت أثناء التحميل
      borderRadius: BorderRadius.circular(AppValues.radiusLg),
      boxShadow: isLoading ? [] : [
        BoxShadow(
          color: AppColors.gradientPurple.withOpacity(0.3),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ويدجت التحميل
  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
      ),
    );
  }
}