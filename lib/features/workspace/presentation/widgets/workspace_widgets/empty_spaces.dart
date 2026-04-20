// lib/features/worksspace/presentation/widgets/workspace_widgets/empty_spaces.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class EmptySpaces extends StatelessWidget {
  final VoidCallback onCreateTap;

  const EmptySpaces({super.key, required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppValues.horizontalPadding, 20,
          AppValues.horizontalPadding, 20),
      child: Column(
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8))
              ],
            ),
            child: const Icon(Icons.folder_open_rounded,
                color: AppColors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text('No Spaces Yet',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -0.3)),
          const SizedBox(height: 8),
          Text(
            'Create your first space to organize\nyour tasks and notes.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 13.5, color: AppColors.textMuted, height: 1.6),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onCreateTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded,
                      color: AppColors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('Create First Space',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}