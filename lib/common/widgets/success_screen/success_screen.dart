import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      this.onPressed,
      this.showTagline = true});

  final String image, title, subTitle;
  final VoidCallback? onPressed;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background image with gradient overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(APPImages.ceylonBackground),
                fit: BoxFit.cover,
                opacity: 0.7,
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
                  dark ? APPColors.dark.withOpacity(0.9) : APPColors.white.withOpacity(0.8),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(APPSizes.defaultSpace),
                child: Column(
                  children: [
                    // Logo at the top
                    Padding(
                      padding: const EdgeInsets.only(top: APPSizes.sm),
                      child: Center(
                        child: Image.asset(
                          APPImages.google, // Replace with your app logo
                          height: 42,
                        ),
                      ),
                    ),

                    const SizedBox(height: APPSizes.spaceBtwSections),

                    // Main Content Container
                    Container(
                      padding: const EdgeInsets.all(APPSizes.lg),
                      decoration: BoxDecoration(
                        color: dark ? APPColors.darkContainer.withOpacity(0.5) : APPColors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(APPSizes.cardRadiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: APPColors.primary.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: APPColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Success Icon Container
                          Container(
                            padding: const EdgeInsets.all(APPSizes.md),
                            decoration: BoxDecoration(
                              color:
                                  dark ? APPColors.darkContainer.withOpacity(0.5) : APPColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(APPSizes.borderRadiusLg),
                            ),
                            child: Icon(
                              Iconsax.tick_circle,
                              color: dark ? APPColors.ceylonYellow : APPColors.success,
                              size: 60,
                            ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwItems),

                          // Image
                          Image(
                            image: AssetImage(image),
                            width: MediaQuery.of(context).size.width * 0.6,
                          ),

                          const SizedBox(height: APPSizes.spaceBtwItems),

                          // Title with highlight effect
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: APPSizes.sm, horizontal: APPSizes.md),
                            decoration: BoxDecoration(
                              color: dark ? APPColors.success.withOpacity(0.2) : APPColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(APPSizes.borderRadiusLg),
                            ),
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: dark ? APPColors.white : APPColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwItems),

                          // Subtitle
                          Text(
                            subTitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: dark ? APPColors.accent : APPColors.textSecondary,
                                ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: APPSizes.spaceBtwSections),

                          // Continue Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: onPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: APPColors.primary,
                                foregroundColor: APPColors.white,
                                padding: const EdgeInsets.symmetric(vertical: APPSizes.buttonHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.buttonRadius),
                                ),
                              ),
                              child: const Text("Continue"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (showTagline) ...[
                      const SizedBox(height: APPSizes.spaceBtwSections),

                      // Tourism Tagline - same as verify email screen
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: APPSizes.md, horizontal: APPSizes.lg),
                        decoration: BoxDecoration(
                          color:
                              dark ? APPColors.darkContainer.withOpacity(0.3) : APPColors.ceylonSand.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(APPSizes.borderRadiusLg),
                          border: Border.all(
                            color: dark ? APPColors.borderSecondary.withOpacity(0.3) : APPColors.borderSecondary,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Experience the Magic of Ceylon",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: dark ? APPColors.ceylonYellow : APPColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                            const SizedBox(height: APPSizes.xs),
                            Text(
                              "Beaches, Wildlife, Ancient Temples, Tea Plantations, and More!",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: dark ? APPColors.accent : APPColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
