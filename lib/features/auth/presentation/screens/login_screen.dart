
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/core_widgets/auth_link_text.dart';
import '../../../../../core/core_widgets/custom_text_field.dart';
import '../../../../../core/core_widgets/gradient_button.dart';
import '../../../../../core/core_widgets/single_link.dart';
import '../../../../../core/core_widgets/social_login_row.dart';
import '../../../../core/core_widgets/seperator_with_text.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppValues.animSlow,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) context.go(RouteNames.home);
          if (state is LoginFailure) showError(context, state.errMessage);
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
                          const SizedBox(height: 48),

                          const AuthHeader(
                            title: AppStrings.welcomeBack,
                            subtitle: AppStrings.welcomeBackSubtitle,
                            showLogoImage: true,
                          ),
                          const SizedBox(height: 36),

                          AuthFormCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                fieldLabel(AppStrings.emailAddress),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _emailController,
                                  hint: 'Enter your email',
                                  prefixIcon: AppIcons.person,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) => v!.isEmpty
                                      ? AppStrings.requiredField
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
                                  textInputAction: TextInputAction.done,
                                  validator: (v) => v!.length < 8
                                      ? AppStrings.passwordMinLength
                                      : null,
                                  suffixIcon: visibilityToggle(
                                    _obscurePassword,
                                        () => setState(() =>
                                    _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                SingleLink(
                                  text: AppStrings.forgotPassword,
                                  onPressed: () =>
                                      context.push(RouteNames.checkEmail),
                                ),
                                const SizedBox(height: 28),

                                GradientButton(
                                  label: AppStrings.signIn,
                                  isLoading: state is LoginLoading,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().login(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),

                                const SeparatorWithText(
                                    text: AppStrings.orContinueWith),
                                const SizedBox(height: 20),

                                SocialLoginRow(children: [
                                  SocialButton(assetPath: 'assets/icons/google.png'),
                                  SocialButton(assetPath: 'assets/icons/apple.png'),
                                  SocialButton(assetPath: 'assets/icons/facebook.png'),
                                ]),
                                const SizedBox(height: 20),

                                AuthLinkText(
                                  message: "Don't have an account? ",
                                  buttonText: AppStrings.signUp,
                                  onPressed: () =>
                                      context.push(RouteNames.register),
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
 
 