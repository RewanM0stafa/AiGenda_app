// lib/features/worksspace/presentation/widgets/workspace_widgets/sheet_field.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class SheetField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final Color accent;
  final int maxLines;

  const SheetField({
    super.key,
    required this.ctrl,
    required this.hint,
    required this.accent,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
          fontSize: 13, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            fontSize: 13, color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppValues.radiusSm - 1),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusSm - 1),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusSm - 1),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
    );
  }
}