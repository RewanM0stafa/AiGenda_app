import 'package:ajenda_app/features/app_startup/onboarding/data/models/onboarding_data.dart';
import 'package:flutter/material.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/utils/navigation_helper.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_page_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late final List<OnboardingModel> onboardingData; // <= List
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    onboardingData = OnboardingData.list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageView(dataModel: onboardingData[index]);
                },
              ),
            ),
            OnboardingIndicator(
              currentIndex: currentIndex,
              length: onboardingData.length,
            ),
            OnboardingButton(
              text: currentIndex == onboardingData.length - 1
                  ? 'Get Started'
                  : 'Next',
              onPressed: () {
                if (currentIndex < onboardingData.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  navigateTo(context, RouteNames.login);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
