

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/core_widgets/gradient_button.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../../../../../../config/routes/route_names.dart';
import '../widgets/auth_helpers.dart';
import 'auth_widget.dart';

class EnterCodeScreen extends StatefulWidget {
  final String? email;
  final String? code; // من Deep Link

  const EnterCodeScreen({super.key, this.email, this.code});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _codeCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isResending = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    // لو جاي من Deep Link حط الكود تلقائي
    if (widget.code != null && widget.code!.isNotEmpty) {
      _codeCtrl.text = widget.code!;
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter a password';
    if (v.length < 8) return 'At least 8 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Add uppercase letter (A-Z)';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Add lowercase letter (a-z)';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Add a number (0-9)';
    if (!v.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      return r'Add a special character e.g. !@#$%';
    }
    return null;
  }

  Future<void> _handleResend() async {
    if (widget.email == null || widget.email!.isEmpty) return;
    setState(() => _isResending = true);
    await context.read<AuthCubit>().forgetPassword(widget.email!);
    if (mounted) setState(() => _isResending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            setState(() => _isSuccess = true);
          }
          if (state is ResetPasswordFailure) {
            showAuthError(context, state.message);
          }
          if (state is ForgetPasswordSuccess) {
            showSuccessMessage(context, 'Code resent! Check your email.');
          }
        },
        builder: (context, state) {
          final isLoading = state is ResetPasswordLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: _isSuccess
                  ? _buildSuccess(context)
                  : _buildForm(context, state, isLoading),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, AuthState state, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.go(RouteNames.checkEmail),
          child: backButton(),
        ),
        const SizedBox(height: 32),

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
                  color: const Color(0xFF6C3FC8).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: const Icon(Icons.lock_reset_rounded,
                color: Colors.white, size: 38),
          ),
        ),
        const SizedBox(height: 24),

        Center(
          child: Text('Reset Password',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E0F5C))),
        ),
        if (widget.email != null) ...[
          const SizedBox(height: 6),
          Center(
            child: Text(
              'We sent a reset code to\n${widget.email}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF8A84A3),
                  height: 1.6),
            ),
          ),
        ],
        const SizedBox(height: 28),

        // ── Code Field ──
        Text('Verification Code',
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8A84A3))),
        const SizedBox(height: 8),
        TextField(
          controller: _codeCtrl,
          keyboardType: TextInputType.text,
          maxLines: null,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E0F5C),
              letterSpacing: 1.0),
          decoration: InputDecoration(
            hintText: 'Paste your reset code here',
            hintStyle: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFFBBB8CC),
                letterSpacing: 0),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              const BorderSide(color: Color(0xFFE8E4F5), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              const BorderSide(color: Color(0xFF7C5CBF), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('💡 Copy the code from your email and paste it here',
            style: GoogleFonts.poppins(
                fontSize: 11,
                color: const Color(0xFF8A84A3),
                height: 1.5)),
        const SizedBox(height: 12),

        // ── Resend ──
        Center(
          child: _isResending
              ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF7C5CBF))))
              : GestureDetector(
            onTap: _handleResend,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Didn't receive it?  ",
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF8A84A3)),
                ),
                TextSpan(
                  text: 'Resend',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF7C5CBF),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF7C5CBF),
                  ),
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Password Fields ──
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Password',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8A84A3))),
              const SizedBox(height: 6),
              TextFormField(
                controller: _newPassCtrl,
                obscureText: _obscureNew,
                validator: _validatePassword,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xFF1E0F5C)),
                decoration: fieldDecoration(
                  hint: r'Min 8 chars, A-Z, 0-9, !@#$',
                  icon: Icons.key_outlined,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureNew
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF8A84A3),
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Text('Confirm Password',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8A84A3))),
              const SizedBox(height: 6),
              TextFormField(
                controller: _confirmPassCtrl,
                obscureText: _obscureConfirm,
                validator: (v) =>
                v != _newPassCtrl.text ? "Passwords don't match" : null,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xFF1E0F5C)),
                decoration: fieldDecoration(
                  hint: '••••••••',
                  icon: Icons.key_outlined,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF8A84A3),
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  r'💡 Must have: A-Z · a-z · 0-9 · special char (!@#$%)',
                  style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      color: const Color(0xFF8A84A3)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        GradientButton(
          label: 'Reset Password',
          isLoading: isLoading,
          onTap: () {
            final code = _codeCtrl.text.trim();
            if (code.isEmpty) {
              showAuthError(context, 'Enter the verification code.');
              return;
            }
            if (_formKey.currentState!.validate()) {
              context.read<AuthCubit>().resetPassword(
                email: widget.email ?? '',
                code: code,
                newPassword: _newPassCtrl.text,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE8FFF0),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF4CAF50), width: 2),
            ),
            child: const Icon(Icons.check_rounded,
                color: Color(0xFF4CAF50), size: 48),
          ),
        ),
        const SizedBox(height: 28),
        Text('Password Reset!',
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E0F5C))),
        const SizedBox(height: 8),
        Text(
          'Your password has been changed successfully.\nYou can now sign in with your new password.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF8A84A3),
              height: 1.6),
        ),
        const SizedBox(height: 40),
        GradientButton(
          label: 'Back to Sign In',
          isLoading: false,
          onTap: () => context.go(RouteNames.login),
        ),
      ],
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/core_widgets/custom_text_field.dart';
import '../../../../../core/core_widgets/gradient_button.dart';
import '../../../../../core/core_widgets/single_link.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_helpers.dart';


class EnterCodeScreen extends StatefulWidget {
  final String? email;
  final String? code; // من Deep Link

  const EnterCodeScreen({super.key, this.email, this.code});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen>
    with SingleTickerProviderStateMixin {
  final _codeCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isResending = false;
  bool _isSuccess = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: AppValues.animSlow);
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
        begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
        parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();

    // لو جاي من Deep Link حط الكود تلقائي
    if (widget.code != null && widget.code!.isNotEmpty) {
      _codeCtrl.text = widget.code!;
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter a password';
    if (v.length < 8) return AppStrings.passwordMinLength;
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Add uppercase letter (A-Z)';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Add lowercase letter (a-z)';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Add a number (0-9)';
    if (!v.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      return r'Add a special character e.g. !@#$%';
    }
    return null;
  }

  Future<void> _handleResend() async {
    if (widget.email == null || widget.email!.isEmpty) return;
    setState(() => _isResending = true);
    await context.read<AuthCubit>().forgetPassword(email: widget.email!);
    if (mounted) setState(() => _isResending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            setState(() => _isSuccess = true);
          }
          if (state is ResetPasswordFailure) {
            showAuthError(context, state.errMessage);
          }
          if (state is ForgetPasswordSuccess) {
            showSuccessMessage(context, 'Code resent! Check your email.');
          }
        },
        builder: (context, state) {
          return AuthBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: _isSuccess
                    ? _buildSuccess(context)
                    : SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.horizontalPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 48),

                          const AuthHeader(
                            title: AppStrings.newPassword,
                            subtitle: AppStrings.createStrongPwd,
                            showLogoImage: true,
                          ),
                          const SizedBox(height: 32),

                          AuthFormCard(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // ── Icon ──
                                Center(
                                    child: buildIconContainer(
                                        AppIcons.resetLock)),
                                const SizedBox(height: 20),

                                // ── Email label ──
                                if (widget.email != null) ...[
                                  Center(
                                    child: Text(
                                      'Reset code sent to\n${widget.email}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        color: AppColors.textMuted,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],

                                // ── Code Field ──
                                buildFieldLabel('Verification Code'),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _codeCtrl,
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 1.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                    'Paste your reset code here',
                                    hintStyle: GoogleFonts.outfit(
                                        fontSize: 13,
                                        color: AppColors.textMuted,
                                        letterSpacing: 0),
                                    filled: true,
                                    fillColor:
                                    Colors.white.withOpacity(0.6),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            AppValues.radiusMd),
                                        borderSide: BorderSide(
                                            color: AppColors.primary
                                                .withOpacity(0.15))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            AppValues.radiusMd),
                                        borderSide: BorderSide(
                                            color: AppColors.primary
                                                .withOpacity(0.15))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            AppValues.radiusMd),
                                        borderSide: const BorderSide(
                                            color: AppColors.primary,
                                            width: 1.5)),
                                    contentPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '💡 Copy the code from your email and paste it here',
                                  style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 16),

                                // ── Resend ──
                                Center(
                                  child: _isResending
                                      ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child:
                                    CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : SingleLink(
                                    text:
                                    "Didn't receive it? Resend",
                                    alignment: Alignment.center,
                                    onPressed: _handleResend,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ── New Password ──
                                buildFieldLabel(AppStrings.newPassword),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _newPassCtrl,
                                  hint: 'Min 8 chars, A-Z, 0-9, !@#\$',
                                  prefixIcon: AppIcons.lockFilled,
                                  obscureText: _obscureNew,
                                  textInputAction: TextInputAction.next,
                                  validator: _validatePassword,
                                  suffixIcon: buildVisibilityToggle(
                                    _obscureNew,
                                        () => setState(
                                            () => _obscureNew = !_obscureNew),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                buildFieldLabel(
                                    AppStrings.confirmPassword),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _confirmPassCtrl,
                                  hint: '••••••••',
                                  prefixIcon: AppIcons.lockFilled,
                                  obscureText: _obscureConfirm,
                                  textInputAction: TextInputAction.done,
                                  validator: (v) =>
                                  v != _newPassCtrl.text
                                      ? AppStrings.passwordsNoMatch
                                      : null,
                                  suffixIcon: buildVisibilityToggle(
                                    _obscureConfirm,
                                        () => setState(() =>
                                    _obscureConfirm =
                                    !_obscureConfirm),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                GradientButton(
                                  label: AppStrings.resetPassword,
                                  isLoading:
                                  state is ResetPasswordLoading,
                                  onTap: () {
                                    if (_formKey.currentState!
                                        .validate()) {
                                      final code =
                                      _codeCtrl.text.trim();
                                      if (code.isEmpty) {
                                        showAuthError(context,
                                            'Enter the verification code.');
                                        return;
                                      }
                                      context
                                          .read<AuthCubit>()
                                          .resetPassword(
                                        email: widget.email ?? '',
                                        code: code,
                                        newPassword:
                                        _newPassCtrl.text,
                                      );
                                    }
                                  },
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
            ),
          );
        },
      ),
    );
  }



  // ── Success State ──
  Widget _buildSuccess(BuildContext context) {
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
                border: Border.all(color: AppColors.success, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.success, size: 52),
            ),
            const SizedBox(height: 28),
            Text(
              'Password Reset! 🎉',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your password has been changed successfully.\nYou can now sign in.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            GradientButton(
              label: 'Back to Sign In',
              onTap: () => context.go(RouteNames.login),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
class EnterCodeScreen extends StatefulWidget {
  final String? email;
  final String? code;
  const EnterCodeScreen({super.key, this.email, this.code});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen>
    with SingleTickerProviderStateMixin {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: AppValues.animSlow);
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool fromDeepLink = widget.email != null && widget.code != null;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(successSnackBar('Password reset successfully!'));
            context.go(RouteNames.login);
          }
          if (state is ResetPasswordFailure) showError(context, state.errMessage);
        },
        builder: (context, state) {
          return AuthBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.horizontalPadding),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        AuthHeader(
                          title: fromDeepLink
                              ? AppStrings.newPassword
                              : 'Check your email',
                          subtitle: fromDeepLink
                              ? AppStrings.createStrongPwd
                              : 'Click the reset link we sent to your email',
                          showLogoImage: true,
                        ),
                        const SizedBox(height: 36),

                        AuthFormCard(
                          child: fromDeepLink
                              ? _buildResetForm(context, state)
                              : _buildWaiting(context),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaiting(BuildContext context) => Column(
    children: [
      iconContainer(AppIcons.resetLock),
      const SizedBox(height: 20),
      Text(
        'Click the reset link we sent\nto your email to continue',
        textAlign: TextAlign.center,
        style: AppTextStyles.authSubtitle,
      ),
      const SizedBox(height: 24),
      GradientButton(label: 'Open email app', onTap: () {}),
      const SizedBox(height: 16),
      SingleLink(
        text: '← Back',
        alignment: Alignment.center,
        onPressed: () => context.pop(),
      ),
    ],
  );

  Widget _buildResetForm(BuildContext context, AuthState state) => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldLabel(AppStrings.newPassword),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _newPasswordController,
          hint: '••••••••',
          prefixIcon: AppIcons.lockFilled,
          obscureText: _obscureNew,
          textInputAction: TextInputAction.next,
          validator: (v) =>
          v!.length < 8 ? AppStrings.passwordMinLength : null,
          suffixIcon: visibilityToggle(
            _obscureNew,
                () => setState(() => _obscureNew = !_obscureNew),
          ),
        ),
        const SizedBox(height: 20),

        fieldLabel(AppStrings.confirmPassword),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _confirmPasswordController,
          hint: '••••••••',
          prefixIcon: AppIcons.lockFilled,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          validator: (v) => v != _newPasswordController.text
              ? AppStrings.passwordsNoMatch
              : null,
          suffixIcon: visibilityToggle(
            _obscureConfirm,
                () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
        const SizedBox(height: 28),

        GradientButton(
          label: AppStrings.resetPassword,
          isLoading: state is ResetPasswordLoading,
          onTap: () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthCubit>().resetPassword(
                email: widget.email!,
                code: widget.code!,
                newPassword: _newPasswordController.text,
              );
            }
          },
        ),
      ],
    ),
  );
}

 */
