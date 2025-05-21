import 'package:ceyloan_360/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:ceyloan_360/utils/constants/colors.dart';
import 'package:ceyloan_360/utils/constants/sizes.dart';
import 'package:ceyloan_360/utils/device/device_utility.dart';
import 'package:ceyloan_360/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Positioned(
        right: APPSizes.defaultSpace,
        bottom: APPDeviceUtils.getBottomNavigationBarHeight(),
        child: ElevatedButton(
            onPressed: () => OnboardingController.instance.nextPage(),
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), backgroundColor: dark ? APPColors.primary : APPColors.black),
            child: const Icon(Iconsax.arrow_right_3)));
  }
}
