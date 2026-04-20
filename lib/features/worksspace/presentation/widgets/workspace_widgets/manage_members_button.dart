// lib/features/worksspace/presentation/widgets/workspace_widgets/manage_members_button.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class ManageMembersButton extends StatelessWidget {
  final VoidCallback onTap;

  const ManageMembersButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppValues.radiusLg),
          border: Border.all(color: AppColors.primary.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppValues.radiusSm - 4),
              ),
              child: const Icon(Icons.people_alt_rounded,
                  color: AppColors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Text('Manage Members',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.primary.withOpacity(0.5), size: 14),
          ],
        ),
      ),
    );
  }
}