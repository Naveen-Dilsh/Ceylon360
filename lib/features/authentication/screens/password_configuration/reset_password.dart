import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: APPSizes.defaultSpace),
                child: Column(
                  children: [
                    // Top Bar with close button and logo
                    Padding(
                      padding: const EdgeInsets.only(top: APPSizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo
                          Image.asset(
                            APPImages.google,
                            height: 42,
                          ),

                          // Close Button
                          InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    dark ? APPColors.darkContainer.withOpacity(0.5) : APPColors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(APPSizes.cardRadiusLg),
                                border: Border.all(
                                  color: dark ? APPColors.borderSecondary.withOpacity(0.3) : APPColors.borderSecondary,
                                ),
                              ),
                              child: Icon(
                                Icons.clear,
                                color: dark ? APPColors.white : APPColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: APPSizes.spaceBtwSections),

                    // Main Content Card
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
                          // Success Icon
                          Container(
                            padding: const EdgeInsets.all(APPSizes.md),
                            decoration: BoxDecoration(
                              color:
                                  dark ? APPColors.darkContainer.withOpacity(0.5) : APPColors.success.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Iconsax.tick_circle,
                              color: dark ? APPColors.ceylonYellow : APPColors.success,
                              size: 50,
                            ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwItems),

                          // Image
                          Image(
                            image: const AssetImage(APPImages.deliveredEmailIllustration),
                            width: APPHelperFunctions.screenWidth() * 0.6,
                          ),

                          const SizedBox(height: APPSizes.spaceBtwItems),

                          // Title
                          Text(
                            'Password Reset Email Sent',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: dark ? APPColors.white : APPColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: APPSizes.spaceBtwItems),

                          // Description
                          Container(
                            padding: const EdgeInsets.all(APPSizes.md),
                            decoration: BoxDecoration(
                              color: dark
                                  ? APPColors.darkContainer.withOpacity(0.3)
                                  : APPColors.ceylonSand.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(APPSizes.borderRadiusLg),
                              border: Border.all(
                                color: dark
                                    ? APPColors.borderSecondary.withOpacity(0.3)
                                    : APPColors.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              "Your Account Security is Our Priority. We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: dark ? APPColors.accent : APPColors.textSecondary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwSections),

                          // Sri Lanka Map Icon
                          Container(
                            padding: const EdgeInsets.all(APPSizes.sm),
                            decoration: BoxDecoration(
                              color: dark
                                  ? APPColors.darkContainer.withOpacity(0.3)
                                  : APPColors.ceylonSand.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(APPSizes.borderRadiusLg),
                              border: Border.all(
                                color: dark
                                    ? APPColors.ceylonYellow.withOpacity(0.3)
                                    : APPColors.secondary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.map,
                                  color: dark ? APPColors.ceylonYellow : APPColors.secondary,
                                ),
                                const SizedBox(width: APPSizes.xs),
                                Text(
                                  "Ceylon 360",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: dark ? APPColors.ceylonYellow : APPColors.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwSections),

                          // Done Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: APPColors.primary,
                                foregroundColor: APPColors.white,
                                padding: const EdgeInsets.symmetric(vertical: APPSizes.buttonHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.buttonRadius),
                                ),
                              ),
                              child: const Text("Done"),
                            ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwItems),

                          // Resend Email Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: dark ? APPColors.ceylonYellow : APPColors.secondary),
                                padding: const EdgeInsets.symmetric(vertical: APPSizes.buttonHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.buttonRadius),
                                ),
                              ),
                              child: Text(
                                "Resend Email",
                                style: TextStyle(color: dark ? APPColors.ceylonYellow : APPColors.secondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: APPSizes.spaceBtwSections),

                    // Tourism Tagline
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: APPSizes.md, horizontal: APPSizes.lg),
                      decoration: BoxDecoration(
                        color: dark ? APPColors.darkContainer.withOpacity(0.3) : APPColors.ceylonSand.withOpacity(0.3),
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

                    const SizedBox(height: APPSizes.defaultSpace),
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
