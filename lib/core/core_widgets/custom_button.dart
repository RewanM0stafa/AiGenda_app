
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutline;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutline) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: AppValues.buttonHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.radiusLg),
            gradient: LinearGradient(
              colors: [
                AppColors.gradientBlue.withOpacity(0.12),
                AppColors.gradientPurple.withOpacity(0.12),
              ],
            ),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      );
    }

    // Filled (same as GradientButton but without loading)
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: AppValues.buttonHeight,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppValues.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientPurple.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
 