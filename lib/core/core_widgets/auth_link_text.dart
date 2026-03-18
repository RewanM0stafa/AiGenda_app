
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AuthLinkText extends StatelessWidget {
  final String? message;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthLinkText({
    super.key,
    this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (message != null && message!.isNotEmpty)
          Text(message!, style: AppTextStyles.bodySmall),
        GestureDetector(
          onTap: onPressed,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: Text(
              buttonText,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

