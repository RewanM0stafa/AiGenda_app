
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_values.dart';

class AppWidgetStyles {
  // ── Cards ──
  static BoxDecoration glassCard({double? radius}) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.white.withOpacity(0.55),
        AppColors.white.withOpacity(0.35),
      ],
    ),
    borderRadius: BorderRadius.circular(radius ?? AppValues.radiusCard),
    border: Border.all(
      color: AppColors.white.withOpacity(0.6),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.08),
        blurRadius: 32,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration regularCard = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppValues.radiusLg),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // ── Gradient Button ──
  static BoxDecoration gradientButton = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(AppValues.radiusLg),
    boxShadow: [
      BoxShadow(
        color: AppColors.gradientPurple.withOpacity(0.35),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // ── Outline Button ──
  static BoxDecoration outlineButton = BoxDecoration(
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
  );

  // ── Social Button ──
  static BoxDecoration socialButton = BoxDecoration(
    borderRadius: BorderRadius.circular(AppValues.radiusLg),
    color: AppColors.white.withOpacity(0.1),
    border: Border.all(
      color: AppColors.white.withOpacity(0.15),
    ),
  );

  // ── Icon Container ──
  static BoxDecoration iconContainer = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(AppValues.radiusIcon),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
 