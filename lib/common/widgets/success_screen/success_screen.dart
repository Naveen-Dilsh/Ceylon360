import 'package:ceyloan_360/common/styles/spacing_styles.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle, this.onPressed});

  final String image, title, subTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: APPSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              /// Image
              Image(
                image: AssetImage(image),
                width: APPHelperFunctions.screenWidth() * 0.6,
              ),

              const SizedBox(height: APPSizes.spaceBtwSections),

              /// Title & Subtitle
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center), // Text

              const SizedBox(height: APPSizes.spaceBtwItems),

              Text(subTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center), // Text

              const SizedBox(height: APPSizes.spaceBtwSections),

              /// Button
              SizedBox(
                  width: double.infinity, child: ElevatedButton(onPressed: onPressed, child: const Text("Continue"))),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
