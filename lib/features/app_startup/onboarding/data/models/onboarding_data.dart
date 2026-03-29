import 'package:ajenda_app/core/constants/app_assets.dart';
import 'package:ajenda_app/core/constants/app_strings.dart';

import 'onboarding_model.dart';


class OnboardingData{

  static List<OnboardingModel> get list => [
    OnboardingModel(
      image: AppAssets.onboarding1,
      title: AppStrings.obTitle1,
      description: AppStrings.obDesc1,
    ),
    OnboardingModel(
      image: AppAssets.onboarding2,
      title:  AppStrings.obTitle2,
      description: AppStrings.obDesc2,
    ),
    OnboardingModel(
      image: AppAssets.onboarding3,
      title: AppStrings.obTitle3,
      description: AppStrings.obDesc3,
    ),
  ];

}