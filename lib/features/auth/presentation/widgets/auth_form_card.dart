
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/constants/app_widget_styles.dart';

class AuthFormCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AuthFormCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.radiusCard),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(AppValues.cardPadding),
          decoration: AppWidgetStyles.glassCard(),
          child: child,
        ),
      ),
    );
  }
}
 
 