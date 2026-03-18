
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
 