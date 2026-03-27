
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_values.dart';
import '../../data/models/profile_model.dart';
import 'profile_avatar.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileModel? profile;
  final VoidCallback onEditTap;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppValues.horizontalPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppValues.radiusLg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(AppValues.radiusLg),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    ProfileAvatar(
                      imageUrl: profile?.profileImage,
                      initials: profile != null
                          ? profile!.firstName[0].toUpperCase()
                          : '?',
                      size: 72,
                      showCameraIcon: true,
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfo()),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Edit Button ──
        Transform.translate(
          offset: const Offset(0, 20),
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
              const Icon(Icons.edit_rounded, color: AppColors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile != null
              ? '@${profile!.firstName}${profile!.secondName}'
              : '@User-Name',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          profile?.email ?? 'user@email.com',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Verified',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
