// ════════════════════════════════════════════════════════════
// 📁 features/profile/presentation/profile_widgets/shared_profile_widgets.dart
// Public classes — لا underscore
// ProfileCard بتاخد stats كـ parameters عشان مش محتاجة تعمل import لـ AppData
// ════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Back Button ──
Widget backBtn() => Container(
  width: 40, height: 40,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFFE8E4F5), width: 1.2),
    boxShadow: [
      BoxShadow(color: const Color(0xFF6C3FC8).withOpacity(0.07),
          blurRadius: 8, offset: const Offset(0, 2))
    ],
  ),
  child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF7C5CBF), size: 20),
);

// ── Section Title ──
Widget sectionTitle(String title) => Text(title,
    style: GoogleFonts.poppins(
        fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1E0F5C)));

// ── Section Card ──
class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFEDE9F8), width: 1),
      boxShadow: [
        BoxShadow(color: const Color(0xFF6C3FC8).withOpacity(0.05),
            blurRadius: 16, offset: const Offset(0, 4))
      ],
    ),
    child: child,
  );
}

// ── Gradient Button ──
class ProfileGradientButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const ProfileGradientButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: isLoading ? null : onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity, height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLoading
              ? [const Color(0xFFAA99D9), const Color(0xFF8870B8)]
              : [const Color(0xFF8B6FD4), const Color(0xFF5B3A9E)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: isLoading
            ? []
            : [BoxShadow(color: const Color(0xFF6C3FC8).withOpacity(0.32),
            blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(width: 22, height: 22,
            child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: Colors.white, letterSpacing: 0.2)),
      ),
    ),
  );
}

// ── Info Banner (error / success) ──
class InfoBanner extends StatelessWidget {
  final String message;
  final bool isError;

  const InfoBanner({super.key, required this.message, required this.isError});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    decoration: BoxDecoration(
      color: isError ? const Color(0xFFFFEEEE) : const Color(0xFFE8FFF0),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
          color: isError ? const Color(0xFFFFCDD2) : const Color(0xFFA5D6B0),
          width: 1),
    ),
    child: Row(
      children: [
        Icon(
          isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
          color: isError ? const Color(0xFFE74C3C) : const Color(0xFF2E7D32),
          size: 17,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message,
              style: GoogleFonts.poppins(
                fontSize: 12, fontWeight: FontWeight.w500,
                color: isError ? const Color(0xFFE74C3C) : const Color(0xFF2E7D32),
              )),
        ),
      ],
    ),
  );
}
class ProfileCard extends StatelessWidget {
  final String initials;
  final String fullName;
  final String email;
  final String? imageUrl; // ✅ إضافة بارامتر الصورة
  final int workspacesCount;
  final int tasksCount;
  final int projectsCount;
  final int notesCount;

  const ProfileCard({
    super.key,
    required this.initials,
    required this.fullName,
    required this.email,
    this.imageUrl, // ✅ جعل الصورة اختيارية
    this.workspacesCount = 0,
    this.tasksCount = 0,
    this.projectsCount = 0,
    this.notesCount = 0,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFEDE9F8), width: 1),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6C3FC8).withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, 6),
        )
      ],
    ),
    child: Column(
      children: [
        Stack(
          children: [
            Container(
              width: 86, height: 86,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEDE6FF),
                  border: Border.all(color: Colors.white, width: 2),
                  // ✅ عرض الصورة لو موجودة
                  image: (imageUrl != null && imageUrl!.isNotEmpty)
                      ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                // ✅ عرض الحروف فقط لو الصورة مش موجودة
                child: (imageUrl == null || imageUrl!.isEmpty)
                    ? Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF5B3A9E),
                    ),
                  ),
                )
                    : null,
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C5CBF), shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // ... باقي الكود كما هو (الاسم، الايميل، الـ stats) ...
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(fullName,
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E0F5C)),
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                Container(
                  width: 9, height: 9,
                  decoration: const BoxDecoration(
                      color: Color(0xFF1A7A47), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 6),
                ),
                const SizedBox(width: 3),
                Text('Verified',
                    style: GoogleFonts.poppins(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A7A47))),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(email,
            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF8A84A3))),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.only(top: 14),
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF0EEF8), width: 1))),
          child: Row(
            children: [
              _StatItem(value: '$workspacesCount', label: 'Workspaces'),
              _StatDivider(),
              _StatItem(value: '$tasksCount', label: 'Tasks'),
              _StatDivider(),
              _StatItem(value: '$projectsCount', label: 'Projects'),
              _StatDivider(),
              _StatItem(value: '$notesCount', label: 'Notes'),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(children: [
      Text(value,
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: const Color(0xFF1E0F5C))),
      const SizedBox(height: 2),
      Text(label,
          style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF8A84A3))),
    ]),
  );
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: const Color(0xFFF0EEF8));
}

// ── Section Label ──
class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
    child: Text(
      label.toUpperCase(),
      style: GoogleFonts.poppins(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: const Color(0xFF8A84A3), letterSpacing: 0.8),
    ),
  );
}

// ── Menu Card ──
class MenuCard extends StatelessWidget {
  final List<MenuItem> items;
  const MenuCard({super.key, required this.items});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFEDE9F8), width: 1),
      boxShadow: [
        BoxShadow(color: const Color(0xFF6C3FC8).withOpacity(0.04),
            blurRadius: 12, offset: const Offset(0, 4))
      ],
    ),
    child: Column(
      children: List.generate(items.length, (i) => Column(
        children: [
          items[i],
          if (i < items.length - 1)
            const Divider(height: 1, thickness: 1, color: Color(0xFFF5F3FF), indent: 64),
        ],
      )),
    ),
  );
}

// ── Menu Item ──
class MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label, sub;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MenuItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.sub,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E0F5C))),
                const SizedBox(height: 1),
                Text(sub,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: const Color(0xFF8A84A3))),
              ],
            ),
          ),
          trailing ?? const Icon(Icons.chevron_right_rounded,
              color: Color(0xFFC8C4DD), size: 20),
        ],
      ),
    ),
  );
}

// ── Toggle Switch ──
class ToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const ToggleSwitch({super.key, required this.value, required this.onChanged});
  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool _val;
  @override
  void initState() { super.initState(); _val = widget.value; }
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { setState(() => _val = !_val); widget.onChanged(_val); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 42, height: 24,
      decoration: BoxDecoration(
        color: _val ? const Color(0xFF7C5CBF) : const Color(0xFFD8CEF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        alignment: _val ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 18, height: 18,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    ),
  );
}

// ── Sign Out Button ──
class SignOutButton extends StatelessWidget {
  final VoidCallback onTap;
  const SignOutButton({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD6D6), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout_rounded, color: Color(0xFFE53935), size: 20),
          const SizedBox(width: 8),
          Text('Sign Out',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: const Color(0xFFE53935))),
        ],
      ),
    ),
  );
}

InputDecoration inputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
  bool enabled = true,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.poppins(
      fontSize: 13,
      color: const Color(0xFFBBB8CC),
    ),
    prefixIcon: Icon(icon, color: const Color(0xFF8A84A3), size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: enabled ? const Color(0xFFF7F5FF) : const Color(0xFFEFEEF5),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE8E4F5), width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF7C5CBF), width: 1.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE8E4F5), width: 1.2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.5),
    ),
    errorStyle: GoogleFonts.poppins(
      fontSize: 11,
      color: const Color(0xFFE74C3C),
    ),
  );
}
