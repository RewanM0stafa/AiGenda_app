
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/core_widgets/app_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool titleIsGradient;
  final bool showLogoImage;
  final bool showAppNameBelowLogo;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleIsGradient = true,
    this.showLogoImage = true,
    this.showAppNameBelowLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogoImage) _buildLogo(),
        if (showLogoImage && title.isNotEmpty) const SizedBox(height: 16),
        if (title.isNotEmpty) ...[
          titleIsGradient
              ? ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: Text(
              title,
              style: AppTextStyles.authTitle.copyWith(
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          )
              : Text(
            title,
            style: AppTextStyles.authTitle,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: AppTextStyles.authSubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(
          width: AppValues.logoHeight,
          height: AppValues.logoHeight,
        ),
        if (showAppNameBelowLogo) ...[
          const SizedBox(height: 12),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: Text(
              'AIGENDA',
              style: AppTextStyles.logoText.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ],
    );
  }
}
 