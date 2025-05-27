import 'package:flutter/material.dart';
import 'package:ceyloan_360/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:ceyloan_360/utils/constants/colors.dart';
import 'package:ceyloan_360/utils/constants/sizes.dart';
import 'package:ceyloan_360/utils/device/device_utility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CeylonOnBoardingDotNavigation extends StatelessWidget {
  const CeylonOnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;

    return Positioned(
      bottom: APPDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: APPSizes.defaultSpace,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: APPSizes.md,
          vertical: APPSizes.sm,
        ),
        decoration: BoxDecoration(
          color: APPColors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(APPSizes.cardRadiusMd),
          border: Border.all(
            color: APPColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: APPColors.primary,
            dotColor: APPColors.grey,
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3,
          ),
        ),
      ),
    );
  }
}
