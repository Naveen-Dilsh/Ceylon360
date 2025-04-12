import 'package:ceyloan_360/features/authentication/screens/onboarding/widgets/onboarding_circular.dart';
import 'package:ceyloan_360/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:ceyloan_360/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:ceyloan_360/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:ceyloan_360/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Horizontal Scrollable Pages
          PageView(
            children: const [
              OnBoardingPage(
                image: APPImages.onBoardingImage1,
                title: "Discover New Horizons",
                subTitle: "Explore fascinating destinations and uncover hidden gems around the world",
              ),
              OnBoardingPage(
                image: APPImages.onBoardingImage2,
                title: "Local Insights & Culture",
                subTitle: "Learn about local traditions, cuisine, and must-visit attractions in each country",
              ),
              OnBoardingPage(
                image: APPImages.onBoardingImage3,
                title: "Plan Your Perfect Journey",
                subTitle: "Personalized travel recommendations tailored to your preferences and interests",
              ),
              // PageView continues...
            ],
          ),

          /// Skip Button
          const OnBoardingSkip(),

          /// Dot Navigation Indicator
          const OnBoardingDotNavigation(),

          /// Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
