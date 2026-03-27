
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/register/register_request_model.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../widgets/auth_helpers.dart';
import '../../../../../../config/routes/route_names.dart';
import '../widgets/auth_validators.dart';
import 'auth_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Imports لملفات الـ Logic والـ Constants
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../../data/models/register/register_request_model.dart';
import '../../../../../../config/routes/route_names.dart';


// Imports للـ Widgets اللي عملنا لها Refactoring
import '../widgets/auth_helpers.dart';
import '../widgets/labeled_auth_field.dart';
import '../widgets/auth_footer.dart';
import 'auth_widget.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onSwitchToSignIn;
  const RegisterScreen({super.key, this.onSwitchToSignIn});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // الـ Controllers
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
          context.push(RouteNames.confirmEmail, extra: {
            'email': state.email,
            'userId': '',
          });
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
                // ── Error Banner ──
                if (state is RegisterFailure) ...[
                  AuthErrorBanner(message: state.message),
                  const SizedBox(height: 14),
                ],

                // ── First & Last Name Row ──
                Row(
                  children: [
                    Expanded(
                      child: LabeledAuthField(
                        label: 'First Name',
                        hint: 'Rewan',
                        controller: _firstNameCtrl,
                        prefixIcon: Icons.person_outline_rounded,
                        enabled: !isLoading,
                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LabeledAuthField(
                        label: 'Last Name',
                        hint: 'Ahmed',
                        controller: _lastNameCtrl,
                        prefixIcon: Icons.person_outline_rounded,
                        enabled: !isLoading,
                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),

                // ── Email Field ──
                LabeledAuthField(
                  label: 'Email',
                  hint: AppStrings.emailHint,
                  controller: _emailCtrl,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  validator: AuthValidators.validateEmail,
                ),

                // ── Password Field ──
                LabeledAuthField(
                  label: 'Password',
                  hint: AppStrings.passwordHint,
                  controller: _passwordCtrl,
                  prefixIcon: Icons.key_outlined,
                  obscure: _obscurePass,
                  enabled: !isLoading,
                  suffixIcon: AuthEyeToggle(
                    obscure: _obscurePass,
                    onToggle: () => setState(() => _obscurePass = !_obscurePass),
                  ),
                  validator: AuthValidators.validatePassword,
                ),

                // ── Confirm Password Field ──
                LabeledAuthField(
                  label: 'Confirm Password',
                  hint: AppStrings.confirmPasswordHint,
                  controller: _confirmCtrl,
                  prefixIcon: Icons.key_outlined,
                  obscure: _obscureConfirm,
                  enabled: !isLoading,
                  suffixIcon: AuthEyeToggle(
                    obscure: _obscureConfirm,
                    onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) => v != _passwordCtrl.text ? "Passwords don't match" : null,
                ),

                // ── Password Hint Label ──
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 4),
                  child: Text(
                    AppStrings.passwordHintLabel,
                    style: AppTextStyles.hintStyle.copyWith(fontSize: 10.5),
                  ),
                ),

                // ── Submit Button ──
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

                // ── Social Login ──
                AuthSocialRow(
                  isLoading: isLoading,
                  onGoogleTap: () {}, // Logic here
                  onFacebookTap: () {},
                ),

                const SizedBox(height: 24),

                // ── Footer ──
                AuthFooter(
                  leadingText: AppStrings.alreadyHaveAccount,
                  actionText: AppStrings.signIn,
                  isLoading: isLoading,
                  onActionTap: widget.onSwitchToSignIn ?? () => context.go(RouteNames.login),
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
import '../../data/models/register/register_request_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../logic/auth_cubit/auth_state.dart';
import 'auth_widget.dart';
import 'package:dartz/dartz.dart' as dartz;


class RegisterScreen extends StatefulWidget {
  final VoidCallback onSwitchToSignIn;
  const RegisterScreen({super.key, required this.onSwitchToSignIn});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
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
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    final dartz.Either<String, void> result = await _authRepo.register(
      RegisterRequest(
        firstName: _firstNameCtrl.text.trim(),
        secondName: _lastNameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text, confirmPassword: '',
      ),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
          (err) => setState(() => _errorMessage = err),
          (_) => context.go('/confirm-email', extra: {
        'userId': '', // سيتم جلبه من storage لو حبيتِ
        'email': _emailCtrl.text.trim(),
      }),
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

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter a password';
    if (v.length < 8) return 'At least 8 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Add at least one uppercase letter (A-Z)';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Add at least one lowercase letter (a-z)';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Add at least one number (0-9)';
    if (!v.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      return 'Add a special character e.g. !@#\$%';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      headerTitle: 'Create Account',
      headerSubtitle: 'join us and start your journey',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null) ...[
              AuthErrorBanner(message: _errorMessage!),
              const SizedBox(height: 14),
            ],
            // First + Last name
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthFieldLabel(label: 'First Name'),
                      const SizedBox(height: 6),
                      AuthTextField(
                        controller: _firstNameCtrl,
                        hint: 'Youmna',
                        prefixIcon: Icons.person_outline_rounded,
                        enabled: !_isLoading,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthFieldLabel(label: 'Last Name'),
                      const SizedBox(height: 6),
                      AuthTextField(
                        controller: _lastNameCtrl,
                        hint: 'Ahmed',
                        prefixIcon: Icons.person_outline_rounded,
                        enabled: !_isLoading,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
            const SizedBox(height: 14),
            const AuthFieldLabel(label: 'Password'),
            const SizedBox(height: 6),
            AuthTextField(
              controller: _passwordCtrl,
              hint: 'Min 8 chars, A-Z, 0-9, !@#\$',
              prefixIcon: Icons.key_outlined,
              obscure: _obscurePass,
              enabled: !_isLoading,
              suffixIcon: AuthEyeToggle(
                obscure: _obscurePass,
                onToggle: () => setState(() => _obscurePass = !_obscurePass),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: 14),
            const AuthFieldLabel(label: 'Confirm Password'),
            const SizedBox(height: 6),
            AuthTextField(
              controller: _confirmCtrl,
              hint: '••••••••',
              prefixIcon: Icons.key_outlined,
              obscure: _obscureConfirm,
              enabled: !_isLoading,
              suffixIcon: AuthEyeToggle(
                obscure: _obscureConfirm,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (v) => v != _passwordCtrl.text ? "Passwords don't match" : null,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                '💡 Password must have: A-Z · a-z · 0-9 · special char (!@#\$%)',
                style: GoogleFonts.poppins(
                    fontSize: 10.5, color: const Color(0xFF8A84A3)),
              ),
            ),
            const SizedBox(height: 20),
            AuthGradientButton(
                label: 'Create Account', isLoading: _isLoading, onTap: _handleSignUp),
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
                onTap: _isLoading ? null : widget.onSwitchToSignIn,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Already have an account?  ',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: const Color(0xFF8A84A3)),
                    ),
                    TextSpan(
                      text: 'Sign In',
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

 */
 