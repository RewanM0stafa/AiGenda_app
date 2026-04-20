// lib/features/worksspace/presentation/widgets/workspace_widgets/space_actions_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import 'sheet_handle.dart';
import 'space_action_row.dart';

class SpaceActionsSheet extends StatelessWidget {
  final dynamic space;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SpaceActionsSheet({
    super.key,
    required this.space,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppValues.radiusCard - 4)),
      ),
      padding: const EdgeInsets.fromLTRB(AppValues.horizontalPadding, 16,
          AppValues.horizontalPadding, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: space.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                    child: Text(space.icon,
                        style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Text(space.name,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: space.color.withOpacity(0.1)),
          const SizedBox(height: 8),
          SpaceActionRow(
            icon: Icons.edit_outlined,
            iconColor: AppColors.gradientBlue,
            iconBg: AppColors.gradientBlue.withOpacity(0.1),
            label: 'Edit Space',
            sub: 'Change name, icon or color',
            onTap: () {
              Navigator.of(context).pop();
              onEdit();
            },
          ),
          SpaceActionRow(
            icon: Icons.delete_outline_rounded,
            iconColor: AppColors.error,
            iconBg: AppColors.error.withOpacity(0.08),
            label: 'Delete Space',
            sub: 'Cannot be undone',
            isDestructive: true,
            onTap: () {
              Navigator.of(context).pop();
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}