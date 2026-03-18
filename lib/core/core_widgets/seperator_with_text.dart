/*
 USES:
 => ( divider + text )
     - ___ Or Login With  ___
     - ___ Or Signup With ___

 */

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';


class SeparatorWithText extends StatelessWidget {
  final String text;
  const SeparatorWithText({super.key, this.text = 'Or'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.white.withOpacity(0.35), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: AppTextStyles.bodySmall),
        ),
        Expanded(
          child: Divider(color: AppColors.white.withOpacity(0.35), thickness: 1),
        ),
      ],
    );
  }
}
