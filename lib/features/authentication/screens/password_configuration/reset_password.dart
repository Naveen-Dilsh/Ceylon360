import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear))],
      ), // AppBar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(APPSizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              Image(
                  image: const AssetImage(APPImages.deliveredEmailIllustration),
                  width: APPHelperFunctions.screenWidth() * 0.6),
              const SizedBox(height: APPSizes.spaceBtwSections),

              /// Title & Subtitle
              Text('Password Reset Email Sent',
                  style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: APPSizes.spaceBtwItems),
              Text(
                  "Your Account Security is Our Priority. We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: APPSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: const Text('Done')),
              ), // SizedBox
              const SizedBox(height: APPSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: const Text('Resend Email')),
              ), // SizedBox
            ],
          ),
        ),
      ),
    );
  }
}
