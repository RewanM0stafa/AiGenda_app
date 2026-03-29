import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../widgets/auth_consumer.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_social_row.dart';
import '../widgets/auth_validators.dart';
import '../widgets/labeled_auth_field.dart';
import 'auth_widget.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onSwitchToSignUp;
  const LoginScreen({super.key, this.onSwitchToSignUp});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final isLoading = state is LoginLoading;

    return AuthConsumer(
      title: AppStrings.loginTitle,
      subtitle: AppStrings.loginSubtitle,
      isLoadingCondition: (state) => state is LoginLoading,
      listener: _handleLoginState,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Email Field
            LabeledAuthField(
              label: 'Email',
              hint: AppStrings.emailHint,
              controller: _emailCtrl,
              prefixIcon: AppIcons.email,
              enabled: !isLoading,
              validator: AuthValidators.validateEmail,
            ),

            //  Password Field
            LabeledAuthField(
              label: 'Password',
              hint: AppStrings.passwordHint,
              controller: _passwordCtrl,
              prefixIcon: AppIcons.lock,
              obscure: _obscurePassword,
              enabled: !isLoading,
              suffixIcon: AuthEyeToggle(
                obscure: _obscurePassword,
                onToggle: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),

            //  Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () => context.push(RouteNames.checkEmail),
                child: const Text(AppStrings.forgotPassword),
              ),
            ),

            const SizedBox(height: 6),

            //   Sign In Button
            AuthGradientButton(
              label: AppStrings.signIn,
              isLoading: isLoading,
              onTap: _onLoginPressed,
            ),

            const SizedBox(height: 20),
            const AuthOrDivider(),
            const SizedBox(height: 16),

            //  Social Login
            AuthSocialRow(
              isLoading: isLoading,
              onGoogleTap: () {},
              onFacebookTap: () {},
              onGithubTap: () {},
            ),

            const SizedBox(height: 24),

            //  Footer
            AuthFooter(
              leadingText: AppStrings.dontHaveAccount,
              actionText: AppStrings.signUp,
              isLoading: isLoading,
              onActionTap:
                  widget.onSwitchToSignUp ??
                  () => context.push(RouteNames.register),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLoginState(BuildContext context, AuthState state) {
    if (state is LoginSuccess) {
      context.go(RouteNames.home);
    }
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
    }
  }
}
