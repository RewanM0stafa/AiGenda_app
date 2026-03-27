
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? titleSuffix;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.titleSuffix,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 14),
            Expanded(child: _buildTitle()),
            trailing ?? _buildDefaultTrailing(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: isDestructive
            ? LinearGradient(colors: [
          AppColors.error.withOpacity(0.15),
          AppColors.error.withOpacity(0.08),
        ])
            : LinearGradient(colors: [
          AppColors.gradientBlue.withOpacity(0.15),
          AppColors.gradientPurple.withOpacity(0.15),
        ]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
        size: 20,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (titleSuffix != null)
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: Text(
                  titleSuffix!,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: AppTextStyles.bodySmall),
        ],
      ],
    );
  }

  Widget _buildDefaultTrailing() {
    if (isDestructive) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.power_settings_new_rounded,
            color: AppColors.error, size: 18),
      );
    }
    return Icon(Icons.arrow_forward_ios_rounded,
        size: 14, color: AppColors.textMuted);
  }
}
