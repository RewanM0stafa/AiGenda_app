
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/constants/app_widget_styles.dart';
import '../../../../../core/core_widgets/gradient_button.dart';
import '../../../../../core/core_widgets/single_link.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_helpers.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String? userId;
  final String? code;
  const ConfirmEmailScreen({super.key, this.userId, this.code});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: AppValues.animSlow);
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    if (widget.userId != null && widget.code != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthCubit>().confirmEmail(
          userId: widget.userId!,
          code: widget.code!,
        );
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ConfirmEmailSuccess) context.go(RouteNames.home);
          if (state is ConfirmEmailFailure) showError(context, state.errMessage);
          if (state is ResendEmailSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              successSnackBar('Email sent! Check your inbox.'),
            );
          }
        },
        builder: (context, state) {
          return AuthBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.horizontalPadding),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      const AuthHeader(
                        title: '',
                        showLogoImage: true,
                        showAppNameBelowLogo: true,
                      ),
                      const Spacer(),
                      AuthFormCard(
                        child: state is ConfirmEmailLoading
                            ? _buildLoading()
                            : _buildContent(context, state),
                      ),
                      const Spacer(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() => Column(
    children: [
      const SizedBox(height: 12),
      const CircularProgressIndicator(
          color: AppColors.primary, strokeWidth: 3),
      const SizedBox(height: 24),
      Text('Verifying your email...', style: AppTextStyles.authCardTitle),
      const SizedBox(height: 12),
    ],
  );

  Widget _buildContent(BuildContext context, AuthState state) => Column(
    children: [
      iconContainer(AppIcons.checkEmail),
      const SizedBox(height: 20),
      Text(
        AppStrings.checkEmailTitle,
        textAlign: TextAlign.center,
        style: AppTextStyles.authCardTitle,
      ),
      const SizedBox(height: 10),
      Text(
        AppStrings.tapLinkToVerify,
        textAlign: TextAlign.center,
        style: AppTextStyles.authInstruction,
      ),
      const SizedBox(height: 28),
      GradientButton(
          label: AppStrings.pleaseOpenEmail, onTap: () {}),
      const SizedBox(height: 16),
      Text(AppStrings.emailOnItsWay, style: AppTextStyles.bodySmall),
      const SizedBox(height: 16),
      state is ResendEmailLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
            color: AppColors.primary, strokeWidth: 2),
      )
          : SingleLink(
        text: AppStrings.resendEmail,
        alignment: Alignment.center,
        onPressed: () =>
            context.read<AuthCubit>().resendConfirmEmail(),
      ),
    ],
  );
}
 