
// 📁 core/core_widgets/shared_helpers.dart
// ملف واحد لكل الـ helper functions المشتركة في كل الـ screens

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_values.dart';


// ── Field Label ──
Widget buildFieldLabel(String text) =>
    Text(text, style: AppTextStyles.fieldLabel);

// ── Visibility Toggle (للـ password fields) ──
Widget buildVisibilityToggle(bool isObscure, VoidCallback onTap) =>
    IconButton(
      icon: Icon(
        isObscure ? AppIcons.visibilityOff : AppIcons.visibility,
        color: AppColors.textMuted,
        size: AppValues.iconSize,
      ),
      onPressed: onTap,
    );

// ── Icon Container (للـ confirm email, reset password) ──
Widget buildIconContainer(IconData icon) => Container(
  width: 80,
  height: 80,
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF6C3FC8).withOpacity(0.35),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Icon(icon, color: Colors.white, size: AppValues.iconSizeLg),
);

// ── Error SnackBar ──
void showAuthError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusSm)),
    ),
  );
}

// ── Success SnackBar ──
void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusSm)),
    ),
  );
}

// ── Warning SnackBar ──
void showWarningMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
      backgroundColor: AppColors.warning,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusSm)),
    ),
  );
}


/*
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/constants/app_widget_styles.dart';

Widget fieldLabel(String text) => Text(text, style: AppTextStyles.fieldLabel);

Widget _visibilityToggle(bool isObscure, VoidCallback onTap) => IconButton(
  icon: Icon(
    isObscure ? AppIcons.visibilityOff : AppIcons.visibility,
    color: AppColors.textMuted,
    size: AppValues.iconSize,
  ),
  onPressed: onTap,
);

Widget iconContainer(IconData icon) => Container(
  width: 72,
  height: 72,
  decoration: AppWidgetStyles.iconContainer,
  child: Icon(icon, color: AppColors.white, size: AppValues.iconSizeLg),
);

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusSm)),
    ),
  );
}

SnackBar successSnackBar(String message) => SnackBar(
  content: Text(message),
  backgroundColor: AppColors.success,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppValues.radiusSm)),
);

Widget _fieldLabel(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 0),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFFB8A6D9),
    ),
  ),
);

Widget visibilityToggle(bool isObscure, VoidCallback onTap) => IconButton(
  icon: Icon(
    isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
    color: AppColors.textMuted,
    size: 20,
  ),
  onPressed: onTap,
);

void showSnackBar(BuildContext context, String message,
    {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor:
      isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape:
      RoundedRectangleBorder(borderRadius:  BorderRadius.circular(AppValues.radiusSm)),
    ),
  );
}

 */