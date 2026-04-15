import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';
import '../../logic/profile_cubit/profile_cubit.dart';
import '../../logic/profile_cubit/profile_state.dart';
import '../profile_widgets/shared_profile_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSuccess = false;

  @override
  void dispose() {
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  String? _validateNewPassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter a new password';
    if (v.length < 8) return 'At least 8 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Add uppercase letter (A-Z)';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Add lowercase letter (a-z)';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Add a number (0-9)';
    if (!v.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      return r'Add a special character e.g. !@#$%';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) setState(() => _isSuccess = true);
          if (state is ChangePasswordFailure)
            showAuthError(context, state.errMessage);
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordLoading;

          return SafeArea(
            child: _isSuccess
                ? _buildSuccess(context)
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
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
                              'Change Password',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E0F5C),
                              ),
                            ),
                          ],
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
                                  color: const Color(
                                    0xFF6C3FC8,
                                  ).withOpacity(0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              AppIcons.lockFilled,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        SectionCard(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPasswordField(
                                  label: 'Current Password',
                                  controller: _currentPassCtrl,
                                  hint: '••••••••',
                                  obscure: _obscureCurrent,
                                  onToggle: () => setState(
                                    () => _obscureCurrent = !_obscureCurrent,
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Enter your current password'
                                      : null,
                                ),
                                const SizedBox(height: 14),

                                _buildPasswordField(
                                  label: 'New Password',
                                  controller: _newPassCtrl,
                                  hint: r'Min 8 chars, A-Z, 0-9, !@#$',
                                  obscure: _obscureNew,
                                  onToggle: () => setState(
                                    () => _obscureNew = !_obscureNew,
                                  ),
                                  validator: _validateNewPassword,
                                ),
                                const SizedBox(height: 14),

                                _buildPasswordField(
                                  label: 'Confirm New Password',
                                  controller: _confirmPassCtrl,
                                  hint: '••••••••',
                                  obscure: _obscureConfirm,
                                  onToggle: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                  validator: (v) => v != _newPassCtrl.text
                                      ? "Passwords don't match"
                                      : null,
                                ),
                                const SizedBox(height: 8),

                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    r'💡 Must have: A-Z · a-z · 0-9 · special char (!@#$%)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.5,
                                      color: const Color(0xFF8A84A3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                ProfileGradientButton(
                                  label: 'Change Password',
                                  isLoading: isLoading,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context
                                          .read<ProfileCubit>()
                                          .changePassword(
                                            currentPassword:
                                                _currentPassCtrl.text,
                                            newPassword: _newPassCtrl.text,
                                          );
                                    }
                                  },
                                ),
                              ],
                            ),
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
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
          obscureText: obscure,
          validator: validator,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1E0F5C),
          ),
          decoration: inputDecoration(
            hint: hint,
            icon: AppIcons.key,
            suffix: IconButton(
              icon: Icon(
                obscure ? AppIcons.visibilityOff : AppIcons.visibility,
                color: const Color(0xFF8A84A3),
                size: 20,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

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
                border: Border.all(color: const Color(0xFF4CAF50), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                AppIcons.check,
                color: Color(0xFF4CAF50),
                size: 52,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Password Changed! 🎉',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E0F5C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your password has been updated successfully.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF8A84A3),
                height: 1.6,
              ),
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
}
