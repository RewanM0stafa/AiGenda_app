import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_values.dart';

//  Field Label
Widget buildFieldLabel(String text) =>
    Text(text, style: AppTextStyles.fieldLabel);

Widget buildVisibilityToggle(bool isObscure, VoidCallback onTap) => IconButton(
  icon: Icon(
    isObscure ? AppIcons.visibilityOff : AppIcons.visibility,
    color: AppColors.textMuted,
    size: AppValues.iconSize,
  ),
  onPressed: onTap,
);

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

//  Error SnackBar
void showAuthError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.radiusSm),
      ),
    ),
  );
}

//  Success SnackBar
void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.radiusSm),
      ),
    ),
  );
}

//  Warning SnackBar
void showWarningMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      backgroundColor: AppColors.warning,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.radiusSm),
      ),
    ),
  );
}
