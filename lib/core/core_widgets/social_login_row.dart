
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
  final String assetPath;
  final VoidCallback? onTap;

  const SocialButton({super.key, required this.assetPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppValues.buttonHeight,
        height: AppValues.buttonHeight,
        decoration: AppWidgetStyles.socialButton,
        child: Center(
          child: Image.asset(
            assetPath,
            width: AppValues.iconSize * 1.2,
            height: AppValues.iconSize * 1.2,
          ),
        ),
      ),
    );
  }
}