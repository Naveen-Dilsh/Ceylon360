import 'package:flutter/material.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        // App Logo with container effect
        Container(
          height: 150,
          width: 150,
          padding: const EdgeInsets.all(APPSizes.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Image(
            image: AssetImage(dark ? APPImages.lightAppLogo : APPImages.darkAppLogo),
          ),
        ),

        const SizedBox(height: APPSizes.spaceBtwItems),

        // Welcome Text
        Text(
          "Welcome Back",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: APPSizes.sm),

        // Subtitle Text
        Text(
          "Login to access your account",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
        ),
      ],
    );
  }
}
