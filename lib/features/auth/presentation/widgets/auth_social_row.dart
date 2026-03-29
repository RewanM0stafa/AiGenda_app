import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/core_widgets/social_button.dart';

class AuthSocialRow extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onGoogleTap;
  final VoidCallback onFacebookTap;
  final VoidCallback onGithubTap;

  const AuthSocialRow({
    super.key,
    required this.isLoading,
    required this.onGoogleTap,
    required this.onFacebookTap,
    required this.onGithubTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          onTap: isLoading ? null : onGoogleTap,
          size: 26,
          child: SvgPicture.asset(AppAssets.googleIcon),
        ),
        const SizedBox(width: 20),
        SocialButton(
          onTap: isLoading ? null : onFacebookTap,
          size: 30,
          child: SvgPicture.asset(AppAssets.facebookIcon),
        ),
        const SizedBox(width: 20),
        SocialButton(
          onTap: isLoading ? null : onGithubTap,
          size: 46,
          child: SvgPicture.asset(AppAssets.githubIcon),
        ),
      ],
    );
  }
}
