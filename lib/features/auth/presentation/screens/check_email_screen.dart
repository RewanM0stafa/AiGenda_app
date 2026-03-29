import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../../../../../../config/routes/route_names.dart';
import '../widgets/auth_consumer.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_validators.dart';
import '../widgets/labeled_auth_field.dart';
import 'auth_widget.dart';


class CheckEmailScreen extends StatelessWidget {
  CheckEmailScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final isLoading = state is ForgetPasswordLoading;

    return AuthConsumer(
      title: 'Forgot Password?',
      subtitle: "Enter your email and we'll send you a reset code.",
      isLoadingCondition: (state) => state is ForgetPasswordLoading,
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          context.push(RouteNames.enterCode, extra: {'email': state.email});
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            LabeledAuthField(
              label: 'Email Address',
              hint: 'email@example.com',
              controller: _emailCtrl,
              prefixIcon: Icons.email_outlined,
              enabled: !isLoading,
              validator: AuthValidators.validateEmail, // استخدمنا الـ Constant validator
            ),
            const SizedBox(height: 32),
            AuthGradientButton(
              label: 'Send Reset Code',
              isLoading: isLoading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().forgetPassword(_emailCtrl.text.trim());
                }
              },
            ),
            const SizedBox(height: 24),
            // الرجوع للخلف باستخدام الـ Helpers
            AuthFooter(
              leadingText: "Remember your password?",
              actionText: "Back to Sign In",
              isLoading: isLoading,
              onActionTap: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}




















/*
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



*/