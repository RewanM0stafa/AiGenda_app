

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../../../../../../config/routes/route_names.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_helpers.dart';
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) context.go(RouteNames.profile);
        if (state is LoginFailure) showAuthError(context, state.message);
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return AuthScaffold(
          headerTitle: AppStrings.loginTitle,
          headerSubtitle: AppStrings.loginSubtitle,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is LoginFailure) ...[
                  AuthErrorBanner(message: state.message),
                  const SizedBox(height: 14),
                ],

                LabeledAuthField(
                  label: 'Email',
                  hint: AppStrings.emailHint,
                  controller: _emailCtrl,
                  prefixIcon: Icons.email_outlined,
                  enabled: !isLoading,
                  validator: AuthValidators.validateEmail,
                ),

                LabeledAuthField(
                  label: 'Password',
                  hint: AppStrings.passwordHint,
                  controller: _passwordCtrl,
                  prefixIcon: Icons.key_outlined,
                  obscure: _obscurePassword,
                  enabled: !isLoading,
                  suffixIcon: AuthEyeToggle(
                    obscure: _obscurePassword,
                    onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : () => context.push(RouteNames.checkEmail),
                    child: const Text(AppStrings.forgotPassword),
                  ),
                ),

                const SizedBox(height: 6),
                AuthGradientButton(
                  label: AppStrings.signIn,
                  isLoading: isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthCubit>().login(_emailCtrl.text.trim(), _passwordCtrl.text);
                    }
                  },
                ),

                const SizedBox(height: 20),
                const AuthOrDivider(),
                const SizedBox(height: 16),

                AuthSocialRow(
                  isLoading: isLoading,
                  onGoogleTap: () {}, // Handle logic
                  onFacebookTap: () {},
                ),

                const SizedBox(height: 24),
                AuthFooter(
                  leadingText: AppStrings.dontHaveAccount,
                  actionText: AppStrings.signUp,
                  isLoading: isLoading,
                  onActionTap: widget.onSwitchToSignUp ?? () => context.push(RouteNames.register),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*
// lib/features/auth/views/sign_up_view.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/models/login/login_request_model.dart';
import '../../data/models/register/register_request_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../logic/auth_cubit/auth_state.dart';
import 'auth_widget.dart';
import 'package:dartz/dartz.dart' as dartz;


class LoginScreen extends StatefulWidget {
  final VoidCallback onSwitchToSignUp;
  const LoginScreen({super.key, required this.onSwitchToSignUp});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  late final AuthRepositoryImpl _authRepo;

  @override
  void initState() {
    super.initState();
    _authRepo = AuthRepositoryImpl(
      apiService: ApiService(Dio()),
      storage: SecureStorageService(),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    final dartz.Either<String, dynamic> result = await _authRepo.login(
      LoginRequest(email: _emailCtrl.text.trim(), password: _passwordCtrl.text),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
          (err) => setState(() => _errorMessage = err),
          (res) => context.go('/home'),
    );
  }

  void _handleGoogle() => _showComingSoon('Google login coming soon!');
  void _handleFacebook() => _showComingSoon('Facebook login coming soon!');

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: const Color(0xFF7C5CBF),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      headerTitle: 'Welcome Back!',
      headerSubtitle: 'welcome back, we missed you',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null) ...[
              AuthErrorBanner(message: _errorMessage!),
              const SizedBox(height: 14),
            ],
            const AuthFieldLabel(label: 'Email'),
            const SizedBox(height: 6),
            AuthTextField(
              controller: _emailCtrl,
              hint: 'email@example.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              validator: (v) =>
              v != null && v.contains('@') ? null : 'Enter a valid email',
            ),
            const SizedBox(height: 16),
            const AuthFieldLabel(label: 'Password'),
            const SizedBox(height: 6),
            AuthTextField(
              controller: _passwordCtrl,
              hint: '••••••••',
              prefixIcon: Icons.key_outlined,
              obscure: _obscurePassword,
              enabled: !_isLoading,
              suffixIcon: AuthEyeToggle(
                obscure: _obscurePassword,
                onToggle: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your password';
                if (v.length < 8) return 'At least 8 characters';
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLoading
                    ? null
                    : () => context.push('/forgot-password'),
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(top: 4, bottom: 2)),
                child: Text('Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF7C5CBF),
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
            const SizedBox(height: 6),
            AuthGradientButton(
                label: 'Sign In', isLoading: _isLoading, onTap: _handleSignIn),
            const SizedBox(height: 20),
            const AuthOrDivider(),
            const SizedBox(height: 16),
            AuthSocialRow(
              isLoading: _isLoading,
              onGoogleTap: _handleGoogle,
              onFacebookTap: _handleFacebook,
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: _isLoading ? null : widget.onSwitchToSignUp,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Don't have an account?  ",
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: const Color(0xFF8A84A3)),
                    ),
                    TextSpan(
                      text: 'Sign Up',
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
          ],
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_values.dart';
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
  final VoidCallback? onSwitchToRegister;
  const LoginScreen({super.key, this.onSwitchToRegister});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

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
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) context.go(RouteNames.home);
          if (state is LoginFailure) showAuthError(context, state.errMessage);
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
                                buildFieldLabel(AppStrings.emailAddress),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _emailCtrl,
                                  hint: 'email@example.com',
                                  prefixIcon: AppIcons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) => v != null &&
                                      v.contains('@')
                                      ? null
                                      : AppStrings.invalidEmail,
                                ),
                                const SizedBox(height: 20),

                                buildFieldLabel(AppStrings.password),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _passwordCtrl,
                                  hint: '••••••••',
                                  prefixIcon: AppIcons.lock,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  validator: (v) => v != null && v.length >= 8
                                      ? null
                                      : AppStrings.passwordMinLength,
                                  suffixIcon: buildVisibilityToggle(
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
                                        email: _emailCtrl.text.trim(),
                                        password: _passwordCtrl.text,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),

                                const SeparatorWithText(
                                    text: AppStrings.orContinueWith),
                                const SizedBox(height: 20),

                                SocialLoginRow(children: [
                                  SocialButton(
                                    icon: Icons.g_mobiledata_rounded,
                                    color: const Color(0xFFDB4437),
                                    onTap: () => showSuccessMessage(
                                        context, 'Google coming soon!'),
                                  ),
                                  SocialButton(
                                    icon: Icons.apple_rounded,
                                    color: Colors.black,
                                    onTap: () => showSuccessMessage(
                                        context, 'Apple coming soon!'),
                                  ),
                                  SocialButton(
                                    icon: Icons.facebook_rounded,
                                    color: const Color(0xFF1877F2),
                                    onTap: () => showSuccessMessage(
                                        context, 'Facebook coming soon!'),
                                  ),
                                ]),
                                const SizedBox(height: 20),

                                AuthLinkText(
                                  message: "Don't have an account? ",
                                  buttonText: AppStrings.signUp,
                                  onPressed: widget.onSwitchToRegister ??
                                          () => context.push(RouteNames.register),
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
*/


/*
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
          if (state is LoginSuccess) context.go(RouteNames.profile); //just now
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
 */
 
 