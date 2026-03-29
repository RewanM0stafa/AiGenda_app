
import 'package:ajenda_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import '../constants/app_values.dart';
import '../constants/app_widget_styles.dart';

class SocialButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final double? size;

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
          child: child ?? const Icon(AppIcons.person),
        ),
      ),
    );
  }
}