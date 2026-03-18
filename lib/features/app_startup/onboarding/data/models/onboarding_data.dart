import 'package:ajenda_app/core/constants/app_assets.dart';
import 'package:ajenda_app/core/constants/app_strings.dart';

import 'onboarding_model.dart';


class OnboardingData{

  static List<OnboardingModel> get list => [
    OnboardingModel(
      image: AppAssets.onboarding1,
      title: "",
      description: "",//AppStrings.onboardingDesc1,
    ),
    OnboardingModel(
      image: AppAssets.onboarding2,
      title: "",//AppStrings.onboardingTitle1,
      description: "", //AppStrings.onboardingDesc2,
    ),
    OnboardingModel(
      image: AppAssets.onboarding3,
      title: "",//AppStrings.onboardingTitle1,
      description: "", // AppStrings.onboardingDesc3,
    ),
  ];

}