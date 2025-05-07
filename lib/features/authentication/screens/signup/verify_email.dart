import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/signup/verify_email_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => AuthenticationRepository.instance.logout(), icon: const Icon(CupertinoIcons.clear))
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

              Text(email ?? "", style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),

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
                      onPressed: () => controller.checkEmailVerificationStatus(), child: const Text("Continue"))),

              const SizedBox(height: APPSizes.spaceBtwItems),

              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.sendEmailVerification(), child: const Text("Resend Email"))),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
