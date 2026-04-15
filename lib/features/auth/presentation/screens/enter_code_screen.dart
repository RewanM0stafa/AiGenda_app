import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../../../../../../config/routes/route_names.dart';
import '../widgets/auth_consumer.dart';
import '../widgets/auth_helpers.dart';
import '../widgets/auth_success_check.dart';
import '../widgets/auth_validators.dart';
import '../widgets/labeled_auth_field.dart';
import 'auth_widget.dart';

class EnterCodeScreen extends StatefulWidget {
  final String? email;
  final String? code;

  const EnterCodeScreen({super.key, this.email, this.code});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    if (widget.code != null) _codeCtrl.text = widget.code!;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final isLoading = state is ResetPasswordLoading;
    final isSuccess = state is ResetPasswordSuccess;

    return AuthConsumer(
      title: isSuccess ? 'Password Reset!' : 'Reset Password',
      subtitle: isSuccess
          ? 'Your password has been changed successfully.'
          : 'We sent a reset code to ${widget.email}',
      isLoadingCondition: (state) => state is ResetPasswordLoading,
      listener: _onStateChange,
      child: isSuccess ? _buildSuccessUI() : _buildResetForm(isLoading),
    );
  }

  Widget _buildResetForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LabeledAuthField(
            label: 'Verification Code',
            hint: 'Paste code from email',
            controller: _codeCtrl,
            prefixIcon: AppIcons.pinOutlined,
          ),
          _buildResendSection(isLoading),
          const SizedBox(height: 20),
          LabeledAuthField(
            label: 'New Password',
            hint: '••••••••',
            controller: _newPassCtrl,
            obscure: _obscureNew,
            prefixIcon: AppIcons.key,
            suffixIcon: AuthEyeToggle(
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            validator: AuthValidators.validatePassword,
          ),
          LabeledAuthField(
            label: 'Confirm Password',
            hint: '••••••••',
            controller: _confirmPassCtrl,
            obscure: _obscureConfirm,
            prefixIcon: AppIcons.resetLock,
            suffixIcon: AuthEyeToggle(
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            validator: (v) =>
                v != _newPassCtrl.text ? "Passwords don't match" : null,
          ),
          const SizedBox(height: 32),
          AuthGradientButton(
            label: 'Reset Password',
            isLoading: isLoading,
            onTap: _onResetPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessUI() {
    return Column(
      children: [
        const AuthSuccessCheck(),
        const SizedBox(height: 40),
        AuthGradientButton(
          label: 'Back to Sign In',
          isLoading: false,
          onTap: () => navigateTo(context, RouteNames.login),
        ),
      ],
    );
  }

  void _onStateChange(BuildContext context, AuthState state) {
    if (state is ForgetPasswordSuccess) {
      showSuccessMessage(context, 'Code resent! Check your email.');
    }
  }

  void _onResetPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(
        email: widget.email ?? '',
        code: _codeCtrl.text.trim(),
        newPassword: _newPassCtrl.text,
      );
    }
  }

  Widget _buildResendSection(bool isLoading) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: isLoading
            ? null
            : () => context.read<AuthCubit>().forgetPassword(widget.email!),
        child: const Text("Resend Code", style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
