import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
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
        // App Logo with custom Ceylon 360 design
        Container(
          height: 150,
          width: 150,
          padding: const EdgeInsets.all(APPSizes.sm),
          decoration: BoxDecoration(
            color: dark ? APPColors.dark.withOpacity(0.6) : APPColors.white.withOpacity(0.8),
            shape: BoxShape.circle,
            border: Border.all(
              color: APPColors.primary.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: dark ? APPColors.dark.withOpacity(0.2) : APPColors.grey.withOpacity(0.2),
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

        // "Ayubowan!" Text with white color and black outline
        Stack(
          children: [
            // Black outline effect using multiple text widgets with small offsets
            Text(
              "ආයුබෝවන්!",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, foreground: Paint()..style = PaintingStyle.stroke),
            ),
            // Main text layer on top with white color
            Text(
              "ආයුබෝවන්!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ],
        ),

        const SizedBox(height: APPSizes.sm),

        // Subtitle Text with silver color and bold
        Text(
          "Welcome to your Sri Lankan adventure",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[300], // Silver color
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
