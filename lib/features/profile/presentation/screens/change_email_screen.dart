import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';
import '../../logic/profile_cubit/profile_cubit.dart';
import '../../logic/profile_cubit/profile_state.dart';
import '../profile_widgets/shared_profile_widgets.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _newEmailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();

  // Step 1: إدخال الإيميل الجديد
  // Step 2: إدخال الكود
  bool _isStep2 = false;
  bool _isSending = false;
  bool _isConfirming = false;
  bool _isSuccess = false;

  String? _errorMsg;
  String? _successMsg;

  @override
  void dispose() {
    _newEmailCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  // ── Step 1: طلب إرسال الكود ──
  Future<void> _sendCode() async {
    final email = _newEmailCtrl.text.trim().toLowerCase();
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMsg = 'Enter a valid email address.');
      return;
    }

    final currentEmail =
        context.read<ProfileCubit>().currentProfile?.email ?? '';
    if (email == currentEmail) {
      setState(
          () => _errorMsg = 'New email must be different from current email.');
      return;
    }

    setState(() {
      _isSending = true;
      _errorMsg = null;
      _successMsg = null;
    });

    await context.read<ProfileCubit>().changeEmail(newEmail: email);

    if (mounted) setState(() => _isSending = false);
  }

  // ── Step 2: تأكيد الكود وتغيير الإيميل ──
  Future<void> _confirmCode() async {
    final code = _codeCtrl.text.replaceAll(RegExp(r'\s+'), '').trim();
    if (code.isEmpty) {
      setState(() => _errorMsg = 'Enter the verification code.');
      return;
    }

    // نتأكد إن الـ id موجود
    var profile = context.read<ProfileCubit>().currentProfile;
    if (profile == null || profile.id.isEmpty) {
      final result = await context.read<ProfileCubit>().profileRepository.getProfile();
      result.fold(
        (failure) {
          setState(() => _errorMsg = 'Could not load profile. Try again.');
          return;
        },
        (p) => profile = p,
      );
    }

    if (profile == null || profile!.id.isEmpty) {
      setState(() => _errorMsg = 'Session expired. Please go back and try again.');
      return;
    }

    setState(() {
      _isConfirming = true;
      _errorMsg = null;
      _successMsg = null;
    });

    debugPrint('=== CONFIRM EMAIL CHANGE ===');
    debugPrint('id: "${profile!.id}"');
    debugPrint('newEmail: "${_newEmailCtrl.text.trim().toLowerCase()}"');
    debugPrint('code: "$code"');

    await context.read<ProfileCubit>().confirmChangeEmail(
          id: profile!.id,
          newEmail: _newEmailCtrl.text.trim().toLowerCase(),
          code: code,
        );

    if (mounted) setState(() => _isConfirming = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // ── Step 1 نجح → انتقل لـ Step 2 ──
          if (state is ChangeEmailSuccess) {
            setState(() {
              _isStep2 = true;
              _successMsg = 'Code sent! Check your new email inbox.';
              _errorMsg = null;
            });
          }
          if (state is ChangeEmailFailure) {
            setState(() {
              _errorMsg = state.errMessage;
              _successMsg = null;
            });
          }

          // ── Step 2 نجح ──
          if (state is ConfirmChangeEmailSuccess) {
            setState(() {
              _isSuccess = true;
              _errorMsg = null;
            });
          }
          if (state is ConfirmChangeEmailFailure) {
            setState(() {
              _errorMsg = state.errMessage;
              _successMsg = null;
            });
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: _isSuccess
                ? _buildSuccessView(context)
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Top Bar ──
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () => context.pop(),
                                child: backBtn()),
                            const SizedBox(width: 14),
                            Text('Change Email',
                                style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1E0F5C))),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // ── Icon ──
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6C3FC8)
                                      .withOpacity(0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: const Icon(Icons.email_outlined,
                                color: Colors.white, size: 36),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Current email label ──
                        Center(
                          child: Column(
                            children: [
                              Text('Current email',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF8A84A3))),
                              const SizedBox(height: 4),
                              Text(
                                context
                                        .read<ProfileCubit>()
                                        .currentProfile
                                        ?.email ??
                                    '',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF7C5CBF)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Card ──
                        SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionTitle(_isStep2
                                  ? 'Enter verification code'
                                  : 'New email address'),
                              const SizedBox(height: 6),
                              Text(
                                _isStep2
                                    ? 'We sent a code to ${_newEmailCtrl.text.trim()}'
                                    : 'Enter the new email you want to use.',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF8A84A3)),
                              ),
                              const SizedBox(height: 16),

                              // ── Error / Success Banner ──
                              if (_errorMsg != null) ...[
                                InfoBanner(
                                    message: _errorMsg!, isError: true),
                                const SizedBox(height: 14),
                              ],
                              if (_successMsg != null) ...[
                                InfoBanner(
                                    message: _successMsg!, isError: false),
                                const SizedBox(height: 14),
                              ],

                              // ── Step 1: إيميل جديد ──
                              if (!_isStep2) ...[
                                _buildField(
                                  label: 'New Email',
                                  controller: _newEmailCtrl,
                                  hint: 'new@example.com',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 20),
                                ProfileGradientButton(
                                  label: 'Send Verification Code',
                                  isLoading: _isSending ||
                                      state is ChangeEmailLoading,
                                  onTap: _sendCode,
                                ),
                              ],

                              // ── Step 2: كود التأكيد ──
                              if (_isStep2) ...[
                                _buildField(
                                  label: 'Verification Code',
                                  controller: _codeCtrl,
                                  hint: 'Paste code from your new email',
                                  icon: Icons.lock_open_rounded,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '💡 Copy the code from your new email and paste it here',
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: const Color(0xFF8A84A3)),
                                ),
                                const SizedBox(height: 20),
                                ProfileGradientButton(
                                  label: 'Confirm Email Change',
                                  isLoading: _isConfirming ||
                                      state is ConfirmChangeEmailLoading,
                                  onTap: _confirmCode,
                                ),
                                const SizedBox(height: 12),

                                // زرار إعادة الإرسال
                                Center(
                                  child: TextButton(
                                    onPressed: (_isSending ||
                                            state is ChangeEmailLoading)
                                        ? null
                                        : () async {
                                            setState(() {
                                              _successMsg = null;
                                              _errorMsg = null;
                                            });
                                            await context
                                                .read<ProfileCubit>()
                                                .changeEmail(
                                                    newEmail: _newEmailCtrl
                                                        .text
                                                        .trim()
                                                        .toLowerCase());
                                          },
                                    child: Text(
                                      "Didn't receive it? Resend",
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: const Color(0xFF7C5CBF),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),

                                // زرار "استخدم إيميل تاني"
                                Center(
                                  child: TextButton(
                                    onPressed: () => setState(() {
                                      _isStep2 = false;
                                      _errorMsg = null;
                                      _successMsg = null;
                                      _codeCtrl.clear();
                                    }),
                                    child: Text(
                                      'Use a different email',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: const Color(0xFF8A84A3),
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              const Color(0xFF8A84A3)),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF0),
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFF4CAF50), width: 2.5),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8))
                ],
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF4CAF50), size: 52),
            ),
            const SizedBox(height: 28),
            Text('Email Changed! 🎉',
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E0F5C))),
            const SizedBox(height: 10),
            Text(
              'Your email has been updated to\n${_newEmailCtrl.text.trim()}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF8A84A3),
                  height: 1.6),
            ),
            const SizedBox(height: 36),
            ProfileGradientButton(
              label: 'Back to Profile',
              isLoading: false,
              onTap: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8A84A3))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style:
              GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1E0F5C)),
          decoration: inputDecoration(hint: hint, icon: icon),
        ),
      ],
    );
  }
}