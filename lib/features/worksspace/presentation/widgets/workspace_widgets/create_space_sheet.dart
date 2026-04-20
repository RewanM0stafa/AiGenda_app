// lib/features/worksspace/presentation/widgets/workspace_widgets/create_space_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import 'sheet_handle.dart';
import 'sheet_label.dart';
import 'sheet_field.dart';
import 'color_dot.dart';
import 'visibility_picker.dart';
import 'icon_picker_sheet.dart';

// قائمة الألوان للـ Space (UI فقط)
const List<Color> _spaceColors = [
  Color(0xFF6C4AB6), Color(0xFF1D9E75), Color(0xFF4A90E2),
  Color(0xFFE11D8E), Color(0xFFF59E0B), Color(0xFFEF4444),
  Color(0xFF0EA5E9), Color(0xFF7C3AED), Color(0xFF0D9488),
  Color(0xFFD97706),
];

class CreateSpaceSheet extends StatefulWidget {
  final ValueChanged<dynamic> onCreated; // _SpaceModel

  const CreateSpaceSheet({super.key, required this.onCreated});

  @override
  State<CreateSpaceSheet> createState() => _CreateSpaceSheetState();
}

class _CreateSpaceSheetState extends State<CreateSpaceSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _icon = '📁';
  int _colorIdx = 0;
  int _visibility = 0;

  Color get _accent => _spaceColors[_colorIdx];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _create() {
  if (_nameCtrl.text.trim().isEmpty) return;
  widget.onCreated({
    'name': _nameCtrl.text.trim(),
    'description': _descCtrl.text.trim(),
    'icon': _icon,
    'color': _accent,
    'visibility': _visibility,
    'totalTasks': 0,
    'completedTasks': 0,
    'noteCount': 0,
  });
  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppValues.radiusCard - 4)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppValues.horizontalPadding, 16,
            AppValues.horizontalPadding, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                      child: Text(_icon,
                          style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 11),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create a Space',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Text('Organize tasks & notes.',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: _accent.withOpacity(0.12)),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SheetLabel('Space Icon'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickIcon,
                      child: Container(
                        width: 70, height: 70,
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.09),
                          borderRadius:
                              BorderRadius.circular(AppValues.radiusLg + 2),
                          border: Border.all(
                              color: _accent.withOpacity(0.3), width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_icon,
                                style: const TextStyle(fontSize: 30)),
                            Text('CHANGE',
                                style: GoogleFonts.poppins(
                                    fontSize: 7,
                                    color: _accent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SheetLabel('Color'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: List.generate(
                          _spaceColors.length,
                          (i) => ColorDot(
                            color: _spaceColors[i],
                            isSelected: _colorIdx == i,
                            onTap: () => setState(() => _colorIdx = i),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const SheetLabel('Space Name'),
            const SizedBox(height: 6),
            SheetField(
                ctrl: _nameCtrl,
                hint: 'e.g. Design, Development',
                accent: _accent),
            const SizedBox(height: 14),
            const SheetLabel('Description (Optional)'),
            const SizedBox(height: 6),
            SheetField(
                ctrl: _descCtrl,
                hint: 'What is this space for?',
                accent: _accent,
                maxLines: 2),
            const SizedBox(height: 18),
            const SheetLabel('Visibility'),
            const SizedBox(height: 10),
            SpaceVisibilityPicker(
              selected: _visibility,
              accent: _accent,
              onChanged: (v) => setState(() => _visibility = v),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: AppValues.buttonHeight - 8,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius:
                            BorderRadius.circular(AppValues.radiusMd - 1),
                        border: Border.all(
                            color: _accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _create,
                    child: Container(
                      height: AppValues.buttonHeight - 8,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius:
                            BorderRadius.circular(AppValues.radiusMd - 1),
                        boxShadow: [
                          BoxShadow(
                              color: _accent.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: Center(
                        child: Text('Create Space',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pickIcon() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IconPickerSheet(
        selectedIcon: _icon,
        accent: _accent,
        onSelected: (icon) => setState(() => _icon = icon),
      ),
    );
  }
}

// تعريف _SpaceModel محلي (كما في الكود الأصلي) – لا يتم تصديره
class _SpaceModel {
  String name;
  String description;
  String icon;
  Color color;
  final int totalTasks;
  final int completedTasks;
  final int noteCount;
  int visibility;

  _SpaceModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.noteCount = 0,
    this.visibility = 0,
  });

  double get completionRate =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
}