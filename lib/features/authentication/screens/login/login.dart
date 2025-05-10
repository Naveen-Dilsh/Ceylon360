import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background image with gradient overlay
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(APPImages.ceylonBackground), // Add a scenic Sri Lanka background image
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  dark ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  dark ? APPColors.dark.withOpacity(1) : APPColors.white.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: APPSpacingStyle.paddingWithAppBarHeight,
                child: Column(
                  children: [
                    // Logo, Title & Sub-Title
                    const TLoginHeader(),

                    // Tourism tagline
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: APPSizes.lg),
                      child: Text(
                        "Discover the Pearl of the Indian Ocean",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: APPColors.light,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),

                    const SizedBox(height: APPSizes.spaceBtwSections),

                    // Form
                    Container(
                      margin: const EdgeInsets.only(top: APPSizes.spaceBtwSections),
                      padding: const EdgeInsets.all(APPSizes.md),
                      decoration: BoxDecoration(
                        color: dark ? APPColors.dark.withOpacity(0.7) : APPColors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(APPSizes.cardRadiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: APPColors.dark.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: APPColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const APPLoginForm(),
                    ),

                    const SizedBox(height: APPSizes.spaceBtwSections),

                    // Divider
                    TFormDivider(dividerText: "Or Start Your Journey With"),

                    const SizedBox(height: APPSizes.spaceBtwSections),

                    // Footer
                    const APPSocialButtons(),

                    // Tourism info teaser
                    Padding(
                      padding: const EdgeInsets.only(top: APPSizes.spaceBtwSections),
                      child: Text(
                        "Explore beautiful beaches, ancient temples, wildlife safaris, and more!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: dark ? APPColors.lightGrey : APPColors.textPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
