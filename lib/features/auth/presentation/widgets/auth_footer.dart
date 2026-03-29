import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

class AuthFooter extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback? onActionTap;
  final bool isLoading;

  const AuthFooter({
    super.key,
    required this.leadingText,
    required this.actionText,
    this.onActionTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: isLoading ? null : onActionTap,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '$leadingText  ',
              style: AppTextStyles.hintStyle,
            ),
            TextSpan(
              text: actionText,
              style: AppTextStyles.authLink,
            ),
          ]),
        ),
      ),
    );
  }
}