import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../widgets/auth_consumer.dart';
import '../widgets/auth_helpers.dart';
import '../widgets/labeled_auth_field.dart';
import 'auth_widget.dart';


class ConfirmEmailScreen extends StatefulWidget {
  final String? userId;
  final String? email;

  const ConfirmEmailScreen({super.key, this.userId, this.email});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final _codeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _userId;
  String? _email;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final cubit = context.read<AuthCubit>();
    final storage = cubit.storage;

    final savedUserId = await storage.getUserId();
    final savedEmail = await storage.getEmail();

    setState(() {
      _userId = widget.userId ?? savedUserId;
      _email = widget.email ?? savedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final isLoading = authCubit.state is ConfirmEmailLoading;

    return AuthConsumer(
      title: 'Verify Your Email',
      subtitle: 'We sent a code to ${_email ?? "your email"}',
      isLoadingCondition: (state) => state is ConfirmEmailLoading,
      listener: _handleStateChanges,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            LabeledAuthField(
              label: 'Verification Code',
              hint: '',
              controller: _codeCtrl,
              enabled: !isLoading,
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              prefixIcon: AppIcons.key,
            ),
            const SizedBox(height: 24),

            AuthGradientButton(
              label: 'Confirm',
              isLoading: isLoading,
              onTap: () => _onConfirmPressed(context),
            ),

            const SizedBox(height: 20),

            _buildResendButton(context, isLoading),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, AuthState state) {
    if (state is ConfirmEmailSuccess) {
      showSuccessMessage(context, 'Email Verified! Redirecting...');
      Future.delayed(
        const Duration(seconds: 2),
        () => navigateTo(context, RouteNames.login),
      );
    }

    if (state is ConfirmEmailFailure) {
      showAuthError(context, state.message);
    }

    if (state is ResendEmailSuccess) {
      showSuccessMessage(context, 'Check your inbox for a new code.');
    }

    if (state is ResendEmailFailure) {
      showAuthError(context, state.message);
    }
  }

  void _onConfirmPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().confirmEmail(
        userId: _userId,
        code: _codeCtrl.text.trim(),
      );
    }
  }

  Widget _buildResendButton(BuildContext context, bool isLoading) {
    return Center(
      child: TextButton(
        onPressed: isLoading
            ? null
            : () {
                if (_email == null || _email!.isEmpty) {
                  showAuthError(context, 'Missing email');
                  return;
                }

                context.read<AuthCubit>().resendConfirmEmail(_email!);
              },
        child: const Text("Didn't get a code? Resend"),
      ),
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }
}
