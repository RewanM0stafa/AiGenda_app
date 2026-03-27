/*
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';
import '../constants/app_widget_styles.dart';

class SocialLoginRow extends StatelessWidget {
  final List<Widget> children;
  const SocialLoginRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children
          .map((c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: c,
      ))
          .toList(),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String? assetPath;
  final VoidCallback? onTap;

  const SocialButton({super.key,  this.assetPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppValues.buttonHeight,
        height: AppValues.buttonHeight,
        decoration: AppWidgetStyles.socialButton,
        child: Center(
          child: (assetPath!= null)? Image.asset(
            assetPath!,
            width: AppValues.iconSize * 1.2,
            height: AppValues.iconSize * 1.2,
          )
          : Icon(Icons.person),
        ),
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';
import '../constants/app_values.dart';
import '../constants/app_widget_styles.dart';

class SocialButton extends StatelessWidget {
  final Widget? child; // ← أي widget ممكن يتحط هنا
  final VoidCallback? onTap;
  final double? size; // للتحكم في ارتفاع وعرض الزر

  const SocialButton({
    super.key,
    this.child,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? AppValues.buttonHeight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: AppWidgetStyles.socialButton,
        child: Center(
          child: child ?? const Icon(Icons.person), // ← افتراضي
        ),
      ),
    );
  }
}