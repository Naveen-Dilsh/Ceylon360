import 'package:ceyloan_360/features/authentication/controllers/onboarding_controller.dart';
import 'package:ceyloan_360/utils/constants/sizes.dart';
import 'package:ceyloan_360/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: APPDeviceUtils.getAppBarHeight() * 0.85,
      right: APPSizes.defaultSpace,
      child: TextButton(onPressed: () => OnboardingController.instance.skipPage(), child: const Text('Skip')),
    );
  }
}
