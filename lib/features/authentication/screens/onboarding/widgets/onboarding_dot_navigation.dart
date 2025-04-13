import 'package:ceyloan_360/features/authentication/controllers/onboarding_controller.dart';
import 'package:ceyloan_360/utils/constants/colors.dart';
import 'package:ceyloan_360/utils/constants/sizes.dart';
import 'package:ceyloan_360/utils/device/device_utility.dart';
import 'package:ceyloan_360/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = APPHelperFunctions.isDarkMode(context);

    return Positioned(
        bottom: APPDeviceUtils.getBottomNavigationBarHeight() + 25,
        left: APPSizes.defaultSpace,
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: ExpandingDotsEffect(activeDotColor: dark ? APPColors.light : APPColors.dark, dotHeight: 6),
        ));
  }
}
