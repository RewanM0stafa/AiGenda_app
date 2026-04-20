// lib/features/worksspace/presentation/widgets/workspace_widgets/space_card.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/constants/app_widget_styles.dart';
import 'circular_progress_painter.dart';
import 'space_stat.dart';
import 'space_actions_sheet.dart';

// قائمة الألوان للـ Space (UI فقط)
const List<Color> _spaceColors = [
  Color(0xFF6C4AB6), Color(0xFF1D9E75), Color(0xFF4A90E2),
  Color(0xFFE11D8E), Color(0xFFF59E0B), Color(0xFFEF4444),
  Color(0xFF0EA5E9), Color(0xFF7C3AED), Color(0xFF0D9488),
  Color(0xFFD97706),
];

class SpaceCard extends StatelessWidget {
  final dynamic space; // _SpaceModel
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SpaceCard({
    super.key,
    required this.space,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _spaceColor => space.color;
  double get _completionRate => space.completionRate;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppValues.radiusCard),
        topRight: Radius.circular(AppValues.radiusLg),
        bottomLeft: Radius.circular(AppValues.radiusLg),
        bottomRight: Radius.circular(AppValues.radiusCard),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppWidgetStyles.glassCard(
            radius: AppValues.radiusCard,
          ).copyWith(
            boxShadow: [
              BoxShadow(
                color: _spaceColor.withOpacity(0.22),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: _spaceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppValues.radiusLg),
                  border: Border.all(color: _spaceColor.withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(space.icon,
                      style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(space.name,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark),
                        overflow: TextOverflow.ellipsis),
                    if (space.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(space.description,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.textMuted),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SpaceStat(
                          icon: Icons.task_alt_rounded,
                          value: '${space.totalTasks}',
                          label: 'tasks',
                          color: _spaceColor,
                        ),
                        const SizedBox(width: 10),
                        SpaceStat(
                          icon: Icons.note_outlined,
                          value: '${space.noteCount}',
                          label: 'notes',
                          color: _spaceColor,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: space.visibility == 0
                                ? AppColors.grey.withOpacity(0.15)
                                : AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                space.visibility == 0
                                    ? Icons.lock_outline_rounded
                                    : Icons.public_rounded,
                                size: 9,
                                color: space.visibility == 0
                                    ? AppColors.textSecondary
                                    : AppColors.success,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                space.visibility == 0 ? 'Private' : 'Public',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: space.visibility == 0
                                      ? AppColors.textSecondary
                                      : AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Right: Progress + Menu
              Column(
                children: [
                  SizedBox(
                    width: 54, height: 54,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(54, 54),
                          painter: CircularProgressPainter(
                            progress: _completionRate,
                            color: _spaceColor,
                            strokeWidth: 5,
                          ),
                        ),
                        Text(
                          '${(_completionRate * 100).toInt()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _spaceColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showActions(context),
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: _spaceColor.withOpacity(0.08),
                        borderRadius:
                            BorderRadius.circular(AppValues.radiusSm - 4),
                        border: Border.all(
                            color: _spaceColor.withOpacity(0.15)),
                      ),
                      child: Icon(Icons.more_horiz_rounded,
                          color: _spaceColor, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SpaceActionsSheet(
        space: space,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}