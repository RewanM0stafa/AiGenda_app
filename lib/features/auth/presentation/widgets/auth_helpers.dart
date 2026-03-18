
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/constants/app_widget_styles.dart';

Widget fieldLabel(String text) => Text(text, style: AppTextStyles.fieldLabel);

Widget visibilityToggle(bool isObscure, VoidCallback onTap) => IconButton(
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
