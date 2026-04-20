// lib/features/worksspace/presentation/widgets/workspace_widgets/space_action_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class SpaceActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, sub;
  final VoidCallback onTap;
  final bool isDestructive;

  const SpaceActionRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.sub,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppValues.verticalPadding / 1.6),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(AppValues.radiusSm)),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDestructive
                              ? AppColors.error
                              : AppColors.textDark)),
                  Text(sub,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted.withOpacity(0.5), size: 18),
          ],
        ),
      ),
    );
  }
}