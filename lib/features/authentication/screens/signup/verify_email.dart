import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../login/login.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.offAll(() => const LoginScreen()), icon: const Icon(CupertinoIcons.clear))
        ],
      ), // AppBar
      body: SingleChildScrollView(
        // Padding to give Default Equal Space on all sides in all screens
        child: Padding(
          padding: const EdgeInsets.all(APPSizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              Image(
                image: const AssetImage(APPImages.deliveredEmailIllustration),
                width: MediaQuery.of(context).size.width * 0.6,
              ), // Image

              const SizedBox(height: APPSizes.spaceBtwSections),

              /// Title & Subtitle
              Text("Verify your email address!",
                  style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),

              const SizedBox(height: APPSizes.spaceBtwItems),

              Text("support@codingwitht.com",
                  style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),

              const SizedBox(height: APPSizes.spaceBtwItems),

              Text(
                  "We have sent a verification link to your email account. Please click the link to verify your email address and continue your registration process.",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),

              const SizedBox(height: APPSizes.spaceBtwItems),

              /// Buttons
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Get.to(
                            () => SuccessScreen(
                              image: APPImages.staticSuccessIllustration,
                              title: "Your account successfully created!",
                              subTitle: "Welcome to Ceyloan360! Discover unique Places in SriLanka.",
                              onPressed: () => Get.to(() => const LoginScreen()),
                            ),
                          ),
                      child: const Text("Continue"))),

              const SizedBox(height: APPSizes.spaceBtwItems),

              SizedBox(
                  width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text("Resend Email"))),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
