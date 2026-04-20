// lib/features/worksspace/presentation/widgets/workspace_widgets/visibility_picker.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class SpaceVisibilityPicker extends StatelessWidget {
  final int selected;
  final Color accent;
  final ValueChanged<int> onChanged;

  const SpaceVisibilityPicker({
    super.key,
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final opts = [
      (Icons.lock_outline_rounded, 'Private', 'Only members can see'),
      (Icons.public_rounded, 'Public', 'Anyone with the link'),
    ];

    return Row(
      children: List.generate(2, (i) {
        final isSelected = selected == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == 0 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: AppValues.animFast,
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accent.withOpacity(0.07)
                      : AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppValues.radiusMd - 1),
                  border: Border.all(
                    color: isSelected
                        ? accent
                        : AppColors.cardBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? accent : AppColors.textHint,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 9, height: 9,
                                decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(opts[i].$2,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? accent
                                      : AppColors.textDark)),
                          Text(opts[i].$3,
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: AppColors.textMuted),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}