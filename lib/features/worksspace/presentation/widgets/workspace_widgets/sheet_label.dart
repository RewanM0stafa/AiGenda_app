// lib/features/worksspace/presentation/widgets/workspace_widgets/sheet_label.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';

class SheetLabel extends StatelessWidget {
  final String text;

  const SheetLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark));
  }
}