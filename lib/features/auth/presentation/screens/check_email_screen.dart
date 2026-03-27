
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/core_widgets/gradient_button.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../../../../../../config/routes/route_names.dart';
import '../widgets/auth_helpers.dart';
import 'auth_widget.dart';

class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({super.key});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEF8),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            context.push(RouteNames.enterCode,
                extra: <String, String>{'email': state.email});
          }
          if (state is ForgetPasswordFailure) {
            showAuthError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgetPasswordLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: backButton(),
                  ),
                  const SizedBox(height: 36),

                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEDE6FF), Color(0xFFD8CEF0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C5CBF).withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: const Icon(Icons.lock_reset_rounded,
                        color: Color(0xFF7C5CBF), size: 32),
                  ),
                  const SizedBox(height: 24),

                  Text('Forgot Password?',
                      style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E0F5C),
                          letterSpacing: -0.3)),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your email and we'll send you a reset code.",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF8A84A3),
                        height: 1.5),
                  ),
                  const SizedBox(height: 36),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF8A84A3))),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !isLoading,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1E0F5C)),
                          validator: (v) =>
                          v != null && v.trim().contains('@')
                              ? null
                              : 'Enter a valid email',
                          decoration: fieldDecoration(
                              hint: 'email@example.com',
                              icon: Icons.email_outlined,
                              isLoading: isLoading),
                        ),
                        const SizedBox(height: 28),

                        GradientButton(
                          label: 'Send Reset Code',
                          isLoading: isLoading,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().forgetPassword(
                                _emailCtrl.text.trim(),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: GestureDetector(
                            onTap: isLoading ? null : () => context.pop(),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '← ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF7C5CBF),
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: 'Back to Sign In',
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}





/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_strings.dart';
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


class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({super.key});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            // روح لـ reset password وابعت الـ email معاها
            context.push(RouteNames.enterCode,
                extra: {'email': state.email});
          }
          if (state is ForgetPasswordFailure) {
            showAuthError(context, state.errMessage);
          }
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 60),

                          const AuthHeader(
                            title: AppStrings.confirmItsYou,
                            subtitle: AppStrings.pleaseVerifyEmail,
                            showLogoImage: true,
                          ),
                          const SizedBox(height: 40),

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
                                  textInputAction: TextInputAction.done,
                                  validator: (v) => v != null && v.contains('@')
                                      ? null
                                      : AppStrings.invalidEmail,
                                ),
                                const SizedBox(height: 28),

                                GradientButton(
                                  label: AppStrings.continue_,
                                  isLoading: state is ForgetPasswordLoading,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().forgetPassword(
                                        email: _emailCtrl.text.trim(),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),

                                SingleLink(
                                  text: '← Back to Login',
                                  alignment: Alignment.center,
                                  onPressed: () => context.pop(),
                                ),
                              ],
                            ),
                          ),
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
class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({super.key});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) context.push(RouteNames.enterCode);
          if (state is ForgetPasswordFailure) showError(context, state.errMessage);
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          const AuthHeader(
                            title: AppStrings.confirmItsYou,
                            subtitle: AppStrings.pleaseVerifyEmail,
                            showLogoImage: true,
                          ),
                          const SizedBox(height: 40),
                          AuthFormCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                fieldLabel(AppStrings.emailAddress),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller: _emailController,
                                  hint: 'you@example.com',
                                  prefixIcon: AppIcons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  validator: (v) => !v!.contains('@')
                                      ? AppStrings.invalidEmail
                                      : null,
                                ),
                                const SizedBox(height: 28),
                                GradientButton(
                                  label: AppStrings.continue_,
                                  isLoading: state is ForgetPasswordLoading,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().forgetPassword(
                                        email: _emailController.text.trim(),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                SingleLink(
                                  text: '← Back to Login',
                                  alignment: Alignment.center,
                                  onPressed: () => context.pop(),
                                ),
                              ],
                            ),
                          ),
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