import 'dart:ui';

import 'package:ajenda_app/config/routes/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/validators.dart';
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
  bool _controllersLoaded = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().currentProfile;
    if (profile != null) {
      _fillControllers(profile);
    } else {
      // لو مفيش profile جيبيه
      context.read<ProfileCubit>().getProfile();
    }
  }

  void _fillControllers(profile) {
    if (_controllersLoaded) return;
    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text = profile.secondName;
    _jobTitleCtrl.text = profile.jobTitle ?? '';
    if (AppDateUtils.isValid(profile.dateOfBirth)) {
      _selectedDate = AppDateUtils.safeParse(profile.dateOfBirth);
    }
    _controllersLoaded = true;
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
    DateTime tempDate = _selectedDate ?? DateTime(2000, 6, 15);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C5CBF).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF8A84A3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedDate = tempDate);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7C5CBF).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'Done',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      initialDateTime: tempDate,
                      minimumDate: DateTime(1940, 1, 1),
                      maximumDate: DateTime(now.year - 5, 12, 31),
                      onDateTimeChanged: (d) => tempDate = d,
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

  Future<void> _pickAvatar() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null && mounted) {
      context.read<ProfileCubit>().uploadAvatar(image.path);
    }
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      showAuthError(context, 'Please select your date of birth.');
      return;
    }
    context.read<ProfileCubit>().updateProfile(
      firstName: _firstNameCtrl.text.trim(),
      secondName: _lastNameCtrl.text.trim(),
      dateOfBirth: AppDateUtils.toApiFormat(_selectedDate!),
      jobTitle: _jobTitleCtrl.text.trim(),
    );
  }

  Future<void> _handleRequestEmailChange() async {
    final newEmail = _newEmailCtrl.text.trim();
    if (AppValidators.validateEmail(newEmail) != null) {
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

    await context.read<ProfileCubit>().confirmChangeEmail(
      newEmail: _newEmailCtrl.text.trim(),
      code: code,
      id: null,
    );

    if (mounted) setState(() => _isConfirmingEmail = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileLoaded) {
            _fillControllers(state.profile);
          } else if (state is UpdateProfileSuccess) {
            showSuccessMessage(context, 'Profile updated successfully!');
            context.pop();
          } else if (state is UpdateProfileFailure) {
            showAuthError(context, state.errMessage);
          } else if (state is UploadAvatarFailure) {
            showAuthError(context, state.errMessage);
          } else if (state is ChangeEmailSuccess) {
            setState(() {
              _isEmailStep2 = true;
              _emailSuccess = 'Code sent! Check your new email.';
              _emailError = null;
            });
          } else if (state is ChangeEmailFailure) {
            setState(() => _emailError = state.errMessage);
          } else if (state is ConfirmChangeEmailSuccess) {
            if (mounted) {
              setState(() {
                _isEmailStep2 = false;
                _emailSuccess = 'Email changed successfully!';
                _newEmailCtrl.clear();
                _emailCodeCtrl.clear();
                _emailError = null;
              });
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.teal.shade700,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  duration: const Duration(seconds: 3),
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Email updated! Redirecting to login...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 2. مسح البيانات المحفوظة
            await SecureStorageService().clearAll();

            // 3. تأخير زمني بسيط لكي يقرأ المستخدم الرسالة قبل اختفاء الشاشة
            await Future.delayed(const Duration(seconds: 2));

            // 4. الانتقال لصفحة تسجيل الدخول
            if (context.mounted) {
              context.go(RouteNames.login);
            }
          } else if (state is ConfirmChangeEmailFailure) {
            setState(() => _emailError = state.errMessage);
          }
        },
        builder: (context, state) {
          final isLoading = state is UpdateProfileLoading;
          final isUploadingAvatar = state is UploadAvatarLoading;
          final profile = context.read<ProfileCubit>().currentProfile;

          if (state is ProfileLoading && profile == null) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF7C5CBF)),
                strokeWidth: 2.5,
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: backBtn(),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Edit Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E0F5C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildAvatar(profile, isUploadingAvatar),
                  const SizedBox(height: 28),

                  SectionCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle('Personal Info'),
                          const SizedBox(height: 16),

                          if (state is UpdateProfileFailure) ...[
                            InfoBanner(
                              message: state.errMessage,
                              isError: true,
                            ),
                            const SizedBox(height: 14),
                          ],

                          Row(
                            children: [
                              Expanded(
                                child: _buildField(
                                  label: 'First Name',
                                  controller: _firstNameCtrl,
                                  hint: 'First name',
                                  icon: AppIcons.person,
                                  validator: (v) =>
                                      AppValidators.validateUsername(v),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildField(
                                  label: 'Last Name',
                                  controller: _lastNameCtrl,
                                  hint: 'Last name',
                                  icon: AppIcons.person,
                                  validator: (v) =>
                                      AppValidators.validateUsername(v),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          Text(
                            'Date of Birth',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8A84A3),
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
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
                                  Icon(
                                    AppIcons.calendar,
                                    color: _selectedDate == null
                                        ? const Color(0xFF8A84A3)
                                        : const Color(0xFF7C5CBF),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _selectedDate == null
                                        ? 'Select your date of birth'
                                        : AppDateUtils.toDisplayFormat(
                                            _selectedDate!,
                                          ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: _selectedDate == null
                                          ? const Color(0xFFBBB8CC)
                                          : const Color(0xFF1E0F5C),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: _selectedDate == null
                                        ? const Color(0xFF8A84A3)
                                        : const Color(0xFF7C5CBF),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          _buildField(
                            label: 'Job Title',
                            controller: _jobTitleCtrl,
                            hint: 'e.g. Software Engineer',
                            icon: AppIcons.work,
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

                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle('Change Email'),
                        const SizedBox(height: 4),
                        Text(
                          'Current: ${profile?.email ?? ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF8A84A3),
                          ),
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
                          label: 'New Email',
                          controller: _newEmailCtrl,
                          hint: 'new@example.com',
                          icon: AppIcons.email,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isEmailStep2,
                        ),
                        const SizedBox(height: 14),

                        if (!_isEmailStep2)
                          ProfileGradientButton(
                            label: 'Send Verification Code',
                            isLoading:
                                _isSendingEmail || state is ChangeEmailLoading,
                            onTap: _handleRequestEmailChange,
                          )
                        else ...[
                          _buildField(
                            label: 'Verification Code',
                            controller: _emailCodeCtrl,
                            hint: 'Paste code from your new email',
                            icon: AppIcons.verified,
                          ),
                          const SizedBox(height: 14),
                          ProfileGradientButton(
                            label: 'Confirm Email Change',
                            isLoading:
                                _isConfirmingEmail ||
                                state is ConfirmChangeEmailLoading,
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
                              child: Text(
                                'Use a different email',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF7C5CBF),
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF7C5CBF),
                                ),
                              ),
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

  Widget _buildAvatar(dynamic profile, bool isUploading) {
    final initials = profile?.initials ?? 'U';
    final avatarUrl = profile?.profileImage;

    return Center(
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)],
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: ClipOval(
              child: isUploading
                  ? Container(
                      color: const Color(0xFFEDE6FF),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF7C5CBF),
                          strokeWidth: 2.5,
                        ),
                      ),
                    )
                  : avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _initialsBox(initials),
                    )
                  : _initialsBox(initials),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: isUploading ? null : _pickAvatar,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isUploading
                      ? const Color(0xFFBBB8CC)
                      : const Color(0xFF7C5CBF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  AppIcons.camera,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _initialsBox(String initials) => Container(
    color: const Color(0xFFEDE6FF),
    child: Center(
      child: Text(
        initials,
        style: GoogleFonts.poppins(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF5B3A9E),
        ),
      ),
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
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8A84A3),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1E0F5C),
          ),
          decoration: inputDecoration(hint: hint, icon: icon, enabled: enabled),
        ),
      ],
    );
  }
}
