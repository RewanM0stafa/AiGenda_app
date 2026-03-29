import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/register/register_request_model.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_helpers.dart';
import '../../../../../../config/routes/route_names.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_social_row.dart';
import '../widgets/auth_validators.dart';
import 'auth_widget.dart';

import '../widgets/labeled_auth_field.dart';
import '../widgets/auth_footer.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onSwitchToSignIn;
  const RegisterScreen({super.key, this.onSwitchToSignIn});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  //  Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.push(
            RouteNames.confirmEmail,
            extra: {'email': state.email, 'userId': ''},
          );
        }
        if (state is RegisterFailure) showAuthError(context, state.message);
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;

        return AuthScaffold(
          headerTitle: AppStrings.registerTitle,
          headerSubtitle: AppStrings.registerSubtitle,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Error Banner
                if (state is RegisterFailure) ...[
                  AuthErrorBanner(message: state.message),
                  const SizedBox(height: 14),
                ],

                //  First & Last Name Row
                Row(
                  children: [
                    Expanded(
                      child: LabeledAuthField(
                        label: 'First Name',
                        hint: 'Rewan',
                        controller: _firstNameCtrl,
                        prefixIcon: AppIcons.person,
                        enabled: !isLoading,
                        validator: (v) =>
                            v?.trim().isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LabeledAuthField(
                        label: 'Last Name',
                        hint: 'Ahmed',
                        controller: _lastNameCtrl,
                        prefixIcon: AppIcons.person,
                        enabled: !isLoading,
                        validator: (v) =>
                            v?.trim().isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),

                //  Email Field
                LabeledAuthField(
                  label: 'Email',
                  hint: AppStrings.emailHint,
                  controller: _emailCtrl,
                  prefixIcon: AppIcons.email,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  validator: AuthValidators.validateEmail,
                ),

                //  Password Field
                LabeledAuthField(
                  label: 'Password',
                  hint: AppStrings.passwordHint,
                  controller: _passwordCtrl,
                  prefixIcon: AppIcons.lock,
                  obscure: _obscurePass,
                  enabled: !isLoading,
                  suffixIcon: AuthEyeToggle(
                    obscure: _obscurePass,
                    onToggle: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                  validator: AuthValidators.validatePassword,
                ),

                //  Confirm Password Field
                LabeledAuthField(
                  label: 'Confirm Password',
                  hint: AppStrings.confirmPasswordHint,
                  controller: _confirmCtrl,
                  prefixIcon: AppIcons.lock,
                  obscure: _obscureConfirm,
                  enabled: !isLoading,
                  suffixIcon: AuthEyeToggle(
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) =>
                      v != _passwordCtrl.text ? "Passwords don't match" : null,
                ),

                //  Password Hint Label
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 4),
                  child: Text(
                    AppStrings.passwordHintLabel,
                    style: AppTextStyles.hintStyle.copyWith(fontSize: 10.5),
                  ),
                ),

                //  Submit Button
                AuthGradientButton(
                  label: AppStrings.signUp,
                  isLoading: isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthCubit>().register(
                        RegisterRequest(
                          firstName: _firstNameCtrl.text.trim(),
                          lastName: _lastNameCtrl.text.trim(),
                          email: _emailCtrl.text.trim(),
                          password: _passwordCtrl.text,
                          confirmPassword: _confirmCtrl.text,
                        ),
                      );
                    }
                  },
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

                // ── Footer ──
                AuthFooter(
                  leadingText: AppStrings.alreadyHaveAccount,
                  actionText: AppStrings.signIn,
                  isLoading: isLoading,
                  onActionTap:
                      widget.onSwitchToSignIn ??
                      () => context.go(RouteNames.login),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
