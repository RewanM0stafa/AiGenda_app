
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class LogoText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double? fontSize;
  final bool useHero;
  final String? heroTag;

  const LogoText({
    super.key,
    this.text = AppStrings.appName,
    this.textAlign = TextAlign.center,
    this.fontSize,
    this.useHero = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final content = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.outfit(
          fontSize: fontSize ?? 40,
          fontWeight: FontWeight.w800,
          letterSpacing: 4,
          color: AppColors.white,
        ),
      ),
    );

    return useHero && heroTag != null
        ? Hero(tag: heroTag!, child: content)
        : content;
  }
}
