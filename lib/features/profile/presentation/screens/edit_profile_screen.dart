// ════════════════════════════════════════════════════════════
// 📁 features/profile/presentation/screens/edit_profile_screen.dart
// Fix 1: Avatar — بعد الرفع الصورة تظهر في الـ UI مباشرة
// Fix 2: Date  — الشهر بيتحفظ صح
// ════════════════════════════════════════════════════════════

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';
import '../../logic/profile_cubit/profile_cubit.dart';
import '../../logic/profile_cubit/profile_state.dart';
import '../profile_widgets/shared_profile_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _jobTitleCtrl = TextEditingController();
  final _newEmailCtrl = TextEditingController();
  final _emailCodeCtrl = TextEditingController();

  DateTime? _selectedDate;
  bool _isEmailStep2 = false;
  bool _isSendingEmail = false;
  bool _isConfirmingEmail = false;
  String? _emailError;
  String? _emailSuccess;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final profile = context.read<ProfileCubit>().currentProfile;
    if (profile == null) return;

    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text = profile.secondName;
    _jobTitleCtrl.text = profile.jobTitle ?? '';

    // Fix: parse date correctly
    if (profile.dateOfBirth != null && profile.dateOfBirth!.isNotEmpty) {
      try {
        final parsed = DateTime.parse(profile.dateOfBirth!);
        if (parsed.year >= 1940) {
          _selectedDate = parsed;
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _jobTitleCtrl.dispose();
    _newEmailCtrl.dispose();
    _emailCodeCtrl.dispose();
    super.dispose();
  }

  // ── Formatted Date (yyyy-MM-dd) ──
  String get _formattedDate {
    if (_selectedDate == null) return '';
    // Fix: padLeft لكل جزء عشان نضمن yyyy-MM-dd
    final y = _selectedDate!.year.toString().padLeft(4, '0');
    final m = _selectedDate!.month.toString().padLeft(2, '0');
    final d = _selectedDate!.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }


  Future<void> _pickDate() async {
    final now = DateTime.now();
    DateTime tempPickedDate = _selectedDate ?? DateTime(2000, 1, 1);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // شفاف عشان يبان اللي وراه
      barrierColor: Colors.black.withOpacity(0.3), // تغميق بسيط للخلفية
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // تأثير التغبيش (Blur)
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              // لون أبيض شفاف جداً مع تدرج خفيف
              color: Colors.white.withOpacity(0.7),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(
                color: Colors.white.withOpacity(0.4), // الحافة الزجاجية
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // ── شريط علوي بشكل عصري (Handle) ──
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C5CBF).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // ── الأزرار (Confirm & Cancel) ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(color: const Color(0xFF8A84A3), fontWeight: FontWeight.w500)),
                      ),
                      // زرار Done بتصميم Gradient صغير
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedDate = tempPickedDate);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7C5CBF).withOpacity(0.3),
                                blurRadius: 8, offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Text('Done',
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── الـ Picker نفسه ──
                Expanded(
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: GoogleFonts.poppins(
                          fontSize: 20,
                          color: const Color(0xFF1E0F5C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: tempPickedDate,
                      minimumDate: DateTime(1940, 1, 1),
                      maximumDate: DateTime(now.year - 5, 12, 31),
                      onDateTimeChanged: (DateTime newDate) {
                        tempPickedDate = newDate;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
/*
  // ── Date Picker ──
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = (_selectedDate != null) ? _selectedDate! : DateTime(2000, 6, 15);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 5),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF7C5CBF),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF1E0F5C),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF7C5CBF)),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      // Fix: setState مباشرة بالـ DateTime اللي رجع من الـ picker
      setState(() => _selectedDate = picked);
    }
  }
*/
  // ── Avatar Picker ──
  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null && mounted) {
      context.read<ProfileCubit>().uploadAvatar(image.path);
    }
  }

  // ── Save Profile ──
  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      showAuthError(context, 'Please select your date of birth.');
      return;
    }
    context.read<ProfileCubit>().updateProfile(
      firstName: _firstNameCtrl.text.trim(),
      secondName: _lastNameCtrl.text.trim(),
      dateOfBirth: _formattedDate,
      jobTitle: _jobTitleCtrl.text.trim(),
    );
  }

  // ── Change Email ──
  Future<void> _handleRequestEmailChange() async {
    final newEmail = _newEmailCtrl.text.trim();
    if (!newEmail.contains('@')) {
      setState(() => _emailError = 'Enter a valid email.');
      return;
    }
    setState(() { _isSendingEmail = true; _emailError = null; _emailSuccess = null; });
    await context.read<ProfileCubit>().changeEmail(newEmail: newEmail);
    if (mounted) setState(() => _isSendingEmail = false);
  }

  Future<void> _handleConfirmEmailChange() async {
    final code = _emailCodeCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => _emailError = 'Enter the verification code.');
      return;
    }
    setState(() { _isConfirmingEmail = true; _emailError = null; _emailSuccess = null; });
    final profile = context.read<ProfileCubit>().currentProfile;
    await context.read<ProfileCubit>().confirmChangeEmail(
      id: profile?.id ?? '',
      newEmail: _newEmailCtrl.text.trim(),
      code: code,
    );
    if (mounted) setState(() => _isConfirmingEmail = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            showSuccessMessage(context, 'Profile updated successfully!');
            context.pop();
          }
          if (state is UpdateProfileFailure) showAuthError(context, state.errMessage);
          if (state is UploadAvatarFailure) showAuthError(context, state.errMessage);
          if (state is ChangeEmailSuccess) {
            setState(() { _isEmailStep2 = true; _emailSuccess = 'Code sent! Check your new email.'; });
          }
          if (state is ChangeEmailFailure) setState(() => _emailError = state.errMessage);
          if (state is ConfirmChangeEmailSuccess) {
            setState(() {
              _isEmailStep2 = false;
              _emailSuccess = 'Email changed successfully!';
              _newEmailCtrl.clear();
              _emailCodeCtrl.clear();
            });
          }
          if (state is ConfirmChangeEmailFailure) setState(() => _emailError = state.errMessage);
        },
        builder: (context, state) {
          final isLoading = state is UpdateProfileLoading;
          final isUploadingAvatar = state is UploadAvatarLoading;

          // Fix: نقرأ الـ profile من أي state — هيكون محدث بعد uploadAvatar
          final profile = context.read<ProfileCubit>().currentProfile;

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top Bar ──
                  Row(
                    children: [
                      GestureDetector(onTap: () => context.pop(), child: backBtn()),
                      const SizedBox(width: 14),
                      Text('Edit Profile',
                          style: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E0F5C))),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Avatar — Fix: بيقرأ من currentProfile اللي بيتحدث بعد الرفع ──
                  _buildAvatar(profile, isUploadingAvatar),
                  const SizedBox(height: 28),

                  // ── Personal Info ──
                  SectionCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle('Personal Info'),
                          const SizedBox(height: 16),

                          if (state is UpdateProfileFailure) ...[
                            InfoBanner(message: state.errMessage, isError: true),
                            const SizedBox(height: 14),
                          ],

                          Row(
                            children: [
                              Expanded(child: _buildField(
                                label: 'First Name', controller: _firstNameCtrl,
                                hint: 'First name', icon: Icons.person_outline_rounded,
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              )),
                              const SizedBox(width: 12),
                              Expanded(child: _buildField(
                                label: 'Last Name', controller: _lastNameCtrl,
                                hint: 'Last name', icon: Icons.person_outline_rounded,
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              )),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ── Date of Birth ──
                          Text('Date of Birth',
                              style: GoogleFonts.poppins(fontSize: 12,
                                  fontWeight: FontWeight.w500, color: const Color(0xFF8A84A3))),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F5FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedDate == null
                                      ? const Color(0xFFE8E4F5)
                                      : const Color(0xFF7C5CBF),
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      color: _selectedDate == null
                                          ? const Color(0xFF8A84A3) : const Color(0xFF7C5CBF),
                                      size: 20),
                                  const SizedBox(width: 12),
                                  // Fix: عرض التاريخ الصح بعد الاختيار
                                  Text(
                                    _selectedDate == null
                                        ? 'Select your date of birth'
                                        : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                                        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                                        '${_selectedDate!.year}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: _selectedDate == null
                                            ? const Color(0xFFBBB8CC) : const Color(0xFF1E0F5C)),
                                  ),
                                  const Spacer(),
                                  Icon(Icons.arrow_drop_down_rounded,
                                      color: _selectedDate == null
                                          ? const Color(0xFF8A84A3) : const Color(0xFF7C5CBF)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          _buildField(
                            label: 'Job Title', controller: _jobTitleCtrl,
                            hint: 'e.g. Software Engineer', icon: Icons.work_outline_rounded,
                          ),
                          const SizedBox(height: 24),

                          ProfileGradientButton(
                            label: 'Save Changes',
                            isLoading: isLoading,
                            onTap: _saveProfile,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Change Email ──
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle('Change Email'),
                        const SizedBox(height: 4),
                        Text(
                          'Current: ${profile?.email ?? ''}',
                          style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF8A84A3)),
                        ),
                        const SizedBox(height: 16),

                        if (_emailError != null) ...[
                          InfoBanner(message: _emailError!, isError: true),
                          const SizedBox(height: 14),
                        ],
                        if (_emailSuccess != null) ...[
                          InfoBanner(message: _emailSuccess!, isError: false),
                          const SizedBox(height: 14),
                        ],

                        _buildField(
                          label: 'New Email', controller: _newEmailCtrl,
                          hint: 'new@example.com', icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isEmailStep2,
                        ),
                        const SizedBox(height: 14),

                        if (!_isEmailStep2)
                          ProfileGradientButton(
                            label: 'Send Verification Code',
                            isLoading: _isSendingEmail || state is ChangeEmailLoading,
                            onTap: _handleRequestEmailChange,
                          )
                        else ...[
                          _buildField(
                            label: 'Verification Code', controller: _emailCodeCtrl,
                            hint: 'Paste code from your new email', icon: Icons.verified_outlined,
                          ),
                          const SizedBox(height: 14),
                          ProfileGradientButton(
                            label: 'Confirm Email Change',
                            isLoading: _isConfirmingEmail || state is ConfirmChangeEmailLoading,
                            onTap: _handleConfirmEmailChange,
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _isEmailStep2 = false;
                                _emailError = null;
                                _emailSuccess = null;
                                _emailCodeCtrl.clear();
                              }),
                              child: Text('Use a different email',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: const Color(0xFF7C5CBF),
                                      decoration: TextDecoration.underline,
                                      decorationColor: const Color(0xFF7C5CBF))),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Avatar Widget — Fix: يقرأ profileImage من currentProfile ──
  Widget _buildAvatar(profile, bool isUploading) {
    final firstName = profile?.firstName ?? '';
    final lastName = profile?.secondName ?? '';
    final initials = [
      if (firstName.isNotEmpty) firstName[0],
      if (lastName.isNotEmpty) lastName[0],
    ].join().toUpperCase();
    final avatarUrl = profile?.profileImage;

    return Center(
      child: Stack(
        children: [
          Container(
            width: 90, height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)]),
            ),
            padding: const EdgeInsets.all(3),
            child: ClipOval(
              child: isUploading
                  ? Container(
                color: const Color(0xFFEDE6FF),
                child: const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFF7C5CBF), strokeWidth: 2.5),
                ),
              )
                  : avatarUrl != null && avatarUrl.isNotEmpty
              // Fix: عرض الصورة من الـ URL بعد الرفع
                  ? Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _initialsWidget(initials),
              )
                  : _initialsWidget(initials),
            ),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: GestureDetector(
              onTap: isUploading ? null : _pickAvatar,
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: isUploading ? const Color(0xFFBBB8CC) : const Color(0xFF7C5CBF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _initialsWidget(String initials) => Container(
    color: const Color(0xFFEDE6FF),
    child: Center(
      child: Text(initials.isEmpty ? 'U' : initials,
          style: GoogleFonts.poppins(
              fontSize: 30, fontWeight: FontWeight.w800,
              color: const Color(0xFF5B3A9E))),
    ),
  );

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500,
                color: const Color(0xFF8A84A3))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1E0F5C)),
          decoration: inputDecoration(hint: hint, icon: icon, enabled: enabled),
        ),
      ],
    );
  }
}
/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../logic/profile_cubit/profile_cubit.dart';
import '../../logic/profile_cubit/profile_state.dart';
import '../profile_widgets/shared_profile_widgets.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _jobTitleCtrl = TextEditingController();
  final _newEmailCtrl = TextEditingController();
  final _emailCodeCtrl = TextEditingController();

  DateTime? _selectedDate;
  bool _isEmailStep2 = false;
  bool _isSendingEmail = false;
  bool _isConfirmingEmail = false;
  String? _emailError;
  String? _emailSuccess;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }
  void _loadProfileData() {
    final profile = context.read<ProfileCubit>().currentProfile;
    if (profile != null) {
      _firstNameCtrl.text = profile.firstName;
      _lastNameCtrl.text = profile.secondName;
      _jobTitleCtrl.text = profile.jobTitle ?? '';

      if (profile.dateOfBirth != null && profile.dateOfBirth!.isNotEmpty) {
        try {
          DateTime parsedDate = DateTime.parse(profile.dateOfBirth!);
          // التأكد إن السنة منطقية قبل تعيينها للمتغير
          if (parsedDate.year > 1940) {
            _selectedDate = parsedDate;
          } else {
            _selectedDate = null;
          }
        } catch (_) {
          _selectedDate = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _jobTitleCtrl.dispose();
    _newEmailCtrl.dispose();
    _emailCodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // التأكد من النطاق المسموح
    final firstDate = DateTime(1940);
    final lastDate = DateTime(now.year - 5);

    // تحديد التاريخ اللي هيبدأ منه الـ Picker
    DateTime initial = (_selectedDate != null && _selectedDate!.year > 1940)
        ? _selectedDate!
        : DateTime(2000);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked; // تحديث الـ State
      });
      // اطبعي ده في الـ Console وشوفي الشهر بيتغير فعلاً ولا لأ
      print("UI SELECTED DATE: ${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}");
    }
  }

  String get _formattedDate {
    if (_selectedDate == null) return '';
    // استخدمي الـ variables مباشرة جوه الـ String
    String year = _selectedDate!.year.toString();
    String month = _selectedDate!.month.toString().padLeft(2, '0');
    String day = _selectedDate!.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> _handleRequestEmailChange() async {
    final newEmail = _newEmailCtrl.text.trim();
    if (!newEmail.contains('@')) {
      setState(() => _emailError = 'Enter a valid email.');
      return;
    }
    setState(() {
      _isSendingEmail = true;
      _emailError = null;
      _emailSuccess = null;
    });
    await context.read<ProfileCubit>().changeEmail(newEmail: newEmail);
    if (mounted) setState(() => _isSendingEmail = false);
  }

  Future<void> _handleConfirmEmailChange() async {
    final code = _emailCodeCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => _emailError = 'Enter the verification code.');
      return;
    }
    setState(() {
      _isConfirmingEmail = true;
      _emailError = null;
      _emailSuccess = null;
    });
    final profile = context.read<ProfileCubit>().currentProfile;
    await context.read<ProfileCubit>().confirmChangeEmail(
      id: profile?.id ?? '',
      newEmail: _newEmailCtrl.text.trim(),
      code: code,
    );
    if (mounted) setState(() => _isConfirmingEmail = false);
  }

  // Inside _EditProfileScreenState
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<ProfileCubit>().updateProfile(
      firstName: _firstNameCtrl.text.trim(),
      secondName: _lastNameCtrl.text.trim(),
      jobTitle: _jobTitleCtrl.text.trim(),
      selectedDate: _selectedDate, // بنبعت الـ DateTime Object نفسه
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            showSuccessMessage(context, 'Profile updated successfully!');
            context.pop();
          } else if (state is UpdateProfileFailure) {
            showAuthError(context, state.errMessage);
          } else if (state is ChangeEmailSuccess) {
            setState(() {
              _isEmailStep2 = true;
              _emailSuccess = 'Code sent! Check your new email.';
            });
          } else if (state is ChangeEmailFailure) {
            setState(() => _emailError = state.errMessage);
          } else if (state is ConfirmChangeEmailSuccess) {
            setState(() {
              _isEmailStep2 = false;
              _emailSuccess = 'Email changed successfully!';
              _newEmailCtrl.clear();
              _emailCodeCtrl.clear();
            });
          } else if (state is ConfirmChangeEmailFailure) {
            setState(() => _emailError = state.errMessage);
          }
        },
        builder: (context, state) {
          final isLoading = state is UpdateProfileLoading;

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(onTap: () => context.pop(), child: backBtn()),
                      const SizedBox(width: 14),
                      Text('Edit Profile',
                          style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E0F5C))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _AvatarWidget(),
                  const SizedBox(height: 28),
                  _PersonalInfoCard(
                    formKey: _formKey,
                    firstNameCtrl: _firstNameCtrl,
                    lastNameCtrl: _lastNameCtrl,
                    jobTitleCtrl: _jobTitleCtrl,
                    selectedDate: _selectedDate,
                    pickDate: _pickDate,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 28),
                  _ChangeEmailCard(
                    newEmailCtrl: _newEmailCtrl,
                    emailCodeCtrl: _emailCodeCtrl,
                    isEmailStep2: _isEmailStep2,
                    isSendingEmail: _isSendingEmail,
                    isConfirmingEmail: _isConfirmingEmail,
                    emailError: _emailError,
                    emailSuccess: _emailSuccess,
                    handleRequest: _handleRequestEmailChange,
                    handleConfirm: _handleConfirmEmailChange,
                    resetStep: () {
                      setState(() {
                        _isEmailStep2 = false;
                        _emailError = null;
                        _emailSuccess = null;
                        _emailCodeCtrl.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C5CBF),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        isLoading ? 'Saving...' : 'Save Changes',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// =====================
/// WIDGETS
/// =====================

class _AvatarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = context.read<ProfileCubit>().currentProfile;
    final initials = [
      if ((profile?.firstName ?? '').isNotEmpty) profile!.firstName[0],
      if ((profile?.secondName ?? '').isNotEmpty) profile!.secondName[0],
    ].join().toUpperCase();

    return Center(
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)]),
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEDE6FF),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  initials.isEmpty ? 'U' : initials,
                  style: GoogleFonts.poppins(
                      fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF5B3A9E)),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF7C5CBF),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Personal Info Card
class _PersonalInfoCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController jobTitleCtrl;
  final DateTime? selectedDate;
  final VoidCallback pickDate;
  final bool isLoading;

  const _PersonalInfoCard({
    required this.formKey,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.jobTitleCtrl,
    required this.selectedDate,
    required this.pickDate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First Name', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 6),
              TextFormField(
                controller: firstNameCtrl,
                decoration: InputDecoration(hintText: 'Enter first name'),
                validator: (val) => val!.isEmpty ? 'Enter first name' : null,
              ),
              const SizedBox(height: 16),
              Text('Last Name', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 6),
              TextFormField(
                controller: lastNameCtrl,
                decoration: InputDecoration(hintText: 'Enter last name'),
                validator: (val) => val!.isEmpty ? 'Enter last name' : null,
              ),
              const SizedBox(height: 16),
              Text('Job Title', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 6),
              TextFormField(
                controller: jobTitleCtrl,
                decoration: InputDecoration(hintText: 'Enter job title'),
              ),
              const SizedBox(height: 16),
              Text('Date of Birth', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedDate == null
                          ? 'Select date'
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                      const Icon(Icons.calendar_month_outlined, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Change Email Card
class _ChangeEmailCard extends StatelessWidget {
  final TextEditingController newEmailCtrl;
  final TextEditingController emailCodeCtrl;
  final bool isEmailStep2;
  final bool isSendingEmail;
  final bool isConfirmingEmail;
  final String? emailError;
  final String? emailSuccess;
  final VoidCallback handleRequest;
  final VoidCallback handleConfirm;
  final VoidCallback resetStep;

  const _ChangeEmailCard({
    required this.newEmailCtrl,
    required this.emailCodeCtrl,
    required this.isEmailStep2,
    required this.isSendingEmail,
    required this.isConfirmingEmail,
    required this.emailError,
    required this.emailSuccess,
    required this.handleRequest,
    required this.handleConfirm,
    required this.resetStep,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Change Email', style: AppTextStyles.fieldLabel),
            const SizedBox(height: 12),
            if (!isEmailStep2) ...[
              TextFormField(
                controller: newEmailCtrl,
                decoration: InputDecoration(hintText: 'Enter new email'),
              ),
              const SizedBox(height: 12),
              if (emailError != null)
                Text(emailError!, style: const TextStyle(color: Colors.red)),
              if (emailSuccess != null)
                Text(emailSuccess!, style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: isSendingEmail ? null : handleRequest,
                child: Text(isSendingEmail ? 'Sending...' : 'Send Code'),
              ),
            ] else ...[
              TextFormField(
                controller: emailCodeCtrl,
                decoration: InputDecoration(hintText: 'Enter verification code'),
              ),
              const SizedBox(height: 12),
              if (emailError != null)
                Text(emailError!, style: const TextStyle(color: Colors.red)),
              if (emailSuccess != null)
                Text(emailSuccess!, style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isConfirmingEmail ? null : handleConfirm,
                      child: Text(isConfirmingEmail ? 'Confirming...' : 'Confirm'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(onPressed: resetStep, child: const Text('Back'))
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}



*/

/*
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppValues.animSlow,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _jobTitleController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _fillControllersOnce() {
    final profile = context.read<ProfileCubit>().current;
    if (profile == null || _prefilled) return;

    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.secondName;
    _emailController.text = profile.email;
    _jobTitleController.text = profile.jobTitle ?? '';
    _prefilled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            showSuccessMessage(context, 'Profile updated successfully!');
            context.pop();
          }
          if (state is UpdateProfileFailure) {
            showAuthError(context, state.errMessage);
          }
          if (state is ProfileError) {
            showAuthError(context, state.errMessage);
          }
        },
        builder: (context, state) {
          _fillControllersOnce();

          final profile = context.read<ProfileCubit>().current;
          final isSaving = state is UpdateProfileLoading;

          return FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              slivers: [
                const ProfileAppBar(title: 'Edit Account'),
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.horizontalPadding,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 16),

                            ProfileAvatar(
                              imageUrl: profile?.profileImage,
                              initials: profile != null && profile.firstName.isNotEmpty
                                  ? profile.firstName[0].toUpperCase()
                                  : '?',
                              size: 100,
                              showCameraIcon: true,
                            ),
                            const SizedBox(height: 12),

                            Text(
                              profile != null
                                  ? '@${profile.firstName}${profile.secondName}'
                                  : '@User-Name',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile?.email ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 28),

                            ProfileSectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) =>
                                        AppColors.primaryGradient.createShader(bounds),
                                    child: Text(
                                      'User Information',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: UnderlineTextField(
                                          label: 'First Name',
                                          controller: _firstNameController,
                                          textInputAction: TextInputAction.next,
                                          validator: (v) =>
                                          v == null || v.trim().isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: UnderlineTextField(
                                          label: 'Last Name',
                                          controller: _lastNameController,
                                          textInputAction: TextInputAction.next,
                                          validator: (v) =>
                                          v == null || v.trim().isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  UnderlineTextField(
                                    label: 'Email',
                                    controller: _emailController,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 20),

                                  UnderlineTextField(
                                    label: 'Job Title',
                                    controller: _jobTitleController,
                                    hint: 'e.g. Flutter Developer',
                                    textInputAction: TextInputAction.done,
                                  ),
                                  const SizedBox(height: 32),

                                  GradientButton(
                                    label: 'Save',
                                    isLoading: isSaving,
                                    onTap: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        context.read<ProfileCubit>().update(
                                          UpdateProfileRequest(
                                            firstName: _firstNameController.text.trim(),
                                            secondName: _lastNameController.text.trim(),
                                            jobTitle: _jobTitleController.text.trim(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  Center(
                                    child: TextButton(
                                      onPressed: () => context.push(RouteNames.changePassword),
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) =>
                                            AppColors.primaryGradient.createShader(bounds),
                                        child: Text(
                                          'Change Password',
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/