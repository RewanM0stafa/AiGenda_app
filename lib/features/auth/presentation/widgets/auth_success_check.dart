import 'package:ajenda_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AuthSuccessCheck extends StatelessWidget {
  const AuthSuccessCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE8FFF0), // لون أخضر فاتح مريح للعين
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.success,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color:  AppColors.success.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color:  AppColors.success,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          // الـ Title والـ Subtitle هيتعرضوا تلقائياً من الـ AuthConsumer
          // لأننا بنغير الـ title بناءً على حالة الـ isSuccess
        ],
      ),
    );
  }
}