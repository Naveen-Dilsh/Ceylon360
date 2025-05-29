import 'package:flutter/material.dart';
import 'package:ceyloan_360/features/authentication/controllers/onboarding/onboarding_controller.dart';

class ProfessionalOnBoardingSkip extends StatelessWidget {
  const ProfessionalOnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      right: 24,
      child: TextButton(
        onPressed: () => OnboardingController.instance.skipPage(),
        style: TextButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Skip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
