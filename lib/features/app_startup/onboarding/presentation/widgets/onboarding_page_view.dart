import 'package:flutter/material.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingPageView extends StatelessWidget {
  //final OnboardingModel model;
  final OnboardingModel dataModel;

  const OnboardingPageView({super.key, required this.dataModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Image.asset(dataModel.image, fit: BoxFit.contain)),
          const SizedBox(height: 24),
          Text(
            dataModel.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            dataModel.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
