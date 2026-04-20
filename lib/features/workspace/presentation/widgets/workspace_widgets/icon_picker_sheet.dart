// lib/features/worksspace/presentation/widgets/workspace_widgets/icon_picker_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import 'sheet_handle.dart';

const List<String> _spaceEmojis = [
  '🎨', '💻', '📊', '🚀', '🎯', '💡', '📋', '🔬',
  '🌟', '🏆', '⚡', '🔥', '💎', '🧠', '🌿', '🎵',
  '📝', '🔧', '📦', '🎬', '🏠', '🌍', '🤖', '⚙️',
];

class IconPickerSheet extends StatelessWidget {
  final String selectedIcon;
  final Color accent;
  final ValueChanged<String> onSelected;

  const IconPickerSheet({
    super.key,
    required this.selectedIcon,
    required this.accent,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppValues.radiusCard - 4)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const SheetHandle(),
          const SizedBox(height: 14),
          Text('Choose Icon',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppValues.horizontalPadding - 8),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
              itemCount: _spaceEmojis.length,
              itemBuilder: (ctx, i) {
                final emoji = _spaceEmojis[i];
                final isSel = emoji == selectedIcon;
                return GestureDetector(
                  onTap: () {
                    onSelected(emoji);
                    Navigator.pop(ctx);
                  },
                  child: AnimatedContainer(
                    duration: AppValues.animFast,
                    decoration: BoxDecoration(
                      color: isSel
                          ? accent.withOpacity(0.12)
                          : AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppValues.radiusSm),
                      border: Border.all(
                          color: isSel ? accent : Colors.transparent,
                          width: 2),
                    ),
                    child: Center(
                      child: Text(emoji,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}