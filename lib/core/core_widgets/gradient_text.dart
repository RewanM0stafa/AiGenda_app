
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final List<Color>? colors;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.center,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: colors ?? [AppColors.gradientBlue, AppColors.gradientPurple],
      ).createShader(bounds),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
 