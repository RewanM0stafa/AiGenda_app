
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/core_widgets/auth_link_text.dart';
import '../../../../../core/core_widgets/custom_text_field.dart';
import '../../../../../core/core_widgets/gradient_button.dart';
import '../../../../../core/core_widgets/social_login_row.dart';
import '../../../../core/core_widgets/seperator_with_text.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) context.go(RouteNames.confirmEmail);
          if (state is RegisterFailure) showError(context, state.errMessage);
        },
        builder: (context, state) {
          return AuthBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.horizontalPadding),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),

                          const AuthHeader(
                            title: AppStrings.getStartedTitle,
                            subtitle: AppStrings.freeForever,
                            showLogoImage: true,
                          ),
                          const SizedBox(height: 28),

                          AuthFormCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // First & Last Name
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          fieldLabel(AppStrings.firstName),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: _firstNameController,
                                            hint: 'Rewan',
                                            prefixIcon: AppIcons.person,
                                            textInputAction:
                                            TextInputAction.next,
                                            validator: (v) => v!.isEmpty
                                                ? AppStrings.requiredField
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          fieldLabel(AppStrings.lastName),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller: _lastNameController,
                                            hint: 'Mostafa',
                                            prefixIcon: AppIcons.person,
                                            textInputAction:
                                            TextInputAction.next,
                                            validator: (v) => v!.isEmpty
                                                ? AppStrings.requiredField
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                fieldLabel(AppStrings.emailAddress),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _emailController,
                                  hint: 'you@example.com',
                                  prefixIcon: AppIcons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) => !v!.contains('@')
                                      ? AppStrings.invalidEmail
                                      : null,
                                ),
                                const SizedBox(height: 20),

                                fieldLabel(AppStrings.password),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _passwordController,
                                  hint: '••••••••',
                                  prefixIcon: AppIcons.lock,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) => v!.length < 8
                                      ? AppStrings.passwordMinLength
                                      : null,
                                  suffixIcon: visibilityToggle(
                                    _obscurePassword,
                                        () => setState(() =>
                                    _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                fieldLabel(AppStrings.confirmPassword),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _confirmPasswordController,
                                  hint: '••••••••',
                                  prefixIcon: AppIcons.lock,
                                  obscureText: _obscureConfirm,
                                  textInputAction: TextInputAction.done,
                                  validator: (v) =>
                                  v != _passwordController.text
                                      ? AppStrings.passwordsNoMatch
                                      : null,
                                  suffixIcon: visibilityToggle(
                                    _obscureConfirm,
                                        () => setState(() =>
                                    _obscureConfirm = !_obscureConfirm),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                GradientButton(
                                  label: AppStrings.signUp,
                                  isLoading: state is RegisterLoading,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().register(
                                        firstName: _firstNameController.text.trim(),
                                        lastName: _lastNameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                        confirmPassword:
                                        _confirmPasswordController.text,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),

                                const SeparatorWithText(
                                    text: AppStrings.orSignUpWith),
                                const SizedBox(height: 20),

                                SocialLoginRow(children: [
                                  SocialButton(assetPath: 'assets/icons/google.png'),
                                  SocialButton(assetPath: 'assets/icons/apple.png'),
                                  SocialButton(assetPath: 'assets/icons/facebook.png'),
                                ]),
                                const SizedBox(height: 20),

                                AuthLinkText(
                                  message: 'Already have an account? ',
                                  buttonText: AppStrings.signIn,
                                  onPressed: () => context.go(RouteNames.login),
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
}
 