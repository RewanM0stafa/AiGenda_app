/*import 'package:ajenda_app/config/routes/route_names.dart';


import 'package:ajenda_app/core/constants/app_colors.dart';
import 'package:ajenda_app/core/constants/app_strings.dart';
import 'package:ajenda_app/core/constants/app_text_styles.dart';
import 'package:ajenda_app/core/core_widgets/gradient_button.dart';
import 'package:ajenda_app/core/core_widgets/gradient_text.dart';
import 'package:ajenda_app/core/utils/navigation_helper.dart';
import 'package:ajenda_app/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:flutter/material.dart';
import 'package:ajenda_app/features/auth/presentation/widgets/auth_header.dart';

/// Welcome / Home screen: "Light Up Your Mind ... With AIGENDA" and Get Started.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: '',
                showLogoImage: true,
                showAppNameBelowLogo: true,
                titleIsGradient: false,
              ),
              const SizedBox(height: 24),
              AuthFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.welcomeTagline,
                      style: AppTextStyles.authCardTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const GradientText(
                      text: AppStrings.welcomeTaglineWithApp,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    GradientButton(
                      text: AppStrings.getStarted,
                      onPressed: () {
                        navigateTo(context, RouteNames.login);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/