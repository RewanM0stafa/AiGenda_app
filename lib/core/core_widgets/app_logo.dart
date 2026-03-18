
import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_values.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool useHero;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.useHero = false,
  });

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      AppAssets.logo,
      width: width,
      height: height ?? AppValues.logoHeight,
      fit: BoxFit.contain,
    );

    return useHero
        ? Hero(tag: 'app_logo', child: logo)
        : logo;
  }
}