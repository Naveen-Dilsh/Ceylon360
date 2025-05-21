import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../password_configuration/reset_password.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

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
                    // Top Bar with back button and logo
                    Padding(
                      padding: const EdgeInsets.only(top: APPSizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back Button
                          InkWell(
                            onTap: () => Navigator.pop(context),
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
                                Icons.arrow_back_ios_new,
                                color: dark ? APPColors.white : APPColors.primary,
                                size: 20,
                              ),
                            ),
                          ),

                          // Logo
                          Image.asset(
                            APPImages.google,
                            height: 42,
                          ),

                          // Spacer to balance the row
                          const SizedBox(width: 40),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Icon
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: dark
                                      ? APPColors.darkContainer.withOpacity(0.5)
                                      : APPColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(APPSizes.md),
                                ),
                                child: Icon(
                                  Iconsax.password_check,
                                  color: dark ? APPColors.ceylonYellow : APPColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: APPSizes.sm),
                              Text(
                                "Forgot Password?",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: dark ? APPColors.white : APPColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: APPSizes.spaceBtwItems),

                          // Subtitle
                          Text(
                            "No worries! It happens to the best of us. Enter your email and we'll send you a link to reset your password.",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: dark ? APPColors.accent : APPColors.textSecondary,
                                ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwSections),

                          // Sri Lanka themed illustration
                          Center(
                            child: Container(
                              height: 120,
                              width: 120,
                              padding: const EdgeInsets.all(APPSizes.md),
                              decoration: BoxDecoration(
                                color: dark
                                    ? APPColors.darkContainer.withOpacity(0.3)
                                    : APPColors.ceylonSand.withOpacity(0.3),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: dark
                                      ? APPColors.ceylonYellow.withOpacity(0.3)
                                      : APPColors.primary.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Iconsax.key,
                                size: 60,
                                color: dark ? APPColors.ceylonYellow : APPColors.secondary,
                              ),
                            ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwSections),

                          // Email Field
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: dark ? APPColors.accent : APPColors.textSecondary,
                              ),
                              prefixIcon: Icon(
                                Iconsax.direct_right,
                                color: dark ? APPColors.ceylonYellow : APPColors.primary,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                borderSide: BorderSide(
                                  color: dark ? APPColors.borderSecondary.withOpacity(0.3) : APPColors.borderSecondary,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                borderSide: BorderSide(
                                  color: dark ? APPColors.ceylonYellow : APPColors.primary,
                                ),
                              ),
                              filled: true,
                              fillColor:
                                  dark ? APPColors.darkContainer.withOpacity(0.3) : APPColors.white.withOpacity(0.9),
                            ),
                          ),

                          const SizedBox(height: APPSizes.spaceBtwSections),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Get.off(() => const ResetPassword()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: APPColors.primary,
                                foregroundColor: APPColors.white,
                                padding: const EdgeInsets.symmetric(vertical: APPSizes.buttonHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.buttonRadius),
                                ),
                              ),
                              child: const Text("Send Reset Link"),
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
