// lib/features/worksspace/presentation/widgets/workspace_widgets/sheet_handle.dart

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36, height: 4,
        decoration: BoxDecoration(
            color: AppColors.cardBorder,
            borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}