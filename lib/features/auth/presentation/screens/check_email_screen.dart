
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