import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ceyloan_360/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:ceyloan_360/utils/constants/colors.dart';
import 'package:ceyloan_360/utils/constants/image_strings.dart';

import 'widgets/onboarding_circular.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_skip.dart';

class ProfessionalOnboardingScreen extends StatelessWidget {
  const ProfessionalOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Page View
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              // Page 1: Heritage & Culture
              ProfessionalOnBoardingPage(
                backgroundImage: APPImages.onBoardingImage1,
                title: "Ancient\nWonders",
                subtitle: "UNESCO World Heritage",
                description:
                    "Discover 2,500 years of rich history across 8 UNESCO World Heritage sites, from ancient kingdoms to colonial architecture.",
                overlayColor: APPColors.primary,
              ),

              // Page 2: Natural Beauty
              ProfessionalOnBoardingPage(
                backgroundImage: APPImages.onBoardingImage2,
                title: "Natural\nParadise",
                subtitle: "Biodiversity Hotspot",
                description:
                    "Experience diverse ecosystems from pristine beaches to misty mountains, home to elephants, leopards, and blue whales.",
                overlayColor: APPColors.ceylonTeal,
              ),

              // Page 3: Authentic Experiences
              ProfessionalOnBoardingPage(
                backgroundImage: APPImages.onBoardingImage3,
                title: "Authentic\nExperiences",
                subtitle: "Local Culture & Cuisine",
                description:
                    "Immerse yourself in vibrant local culture, savor world-famous Ceylon tea, and taste authentic Sri Lankan cuisine.",
                overlayColor: APPColors.secondary,
              ),
            ],
          ),

          // Bottom Controls
          const ProfessionalOnBoardingControls(),
        ],
      ),
    );
  }
}
