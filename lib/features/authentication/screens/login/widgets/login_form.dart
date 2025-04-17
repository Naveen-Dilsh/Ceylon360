import 'package:ceyloan_360/features/authentication/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../password_configuration/forget_password.dart';

class APPLoginForm extends StatelessWidget {
  const APPLoginForm({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: APPSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: "Email"),
            ), // TextFormField
            const SizedBox(height: APPSizes.spaceBtwInputFields),

            /// Password
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: "Password",
                suffixIcon: Icon(Iconsax.eye_slash),
              ), // InputDecoration
            ), // TextFormField
            const SizedBox(height: APPSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text("remember me"),
                  ],
                ), // Row
                /// Forget Password
                TextButton(
                    onPressed: () => Get.to(() => const ForgotPassword()), child: const Text("Forget Password?")),
              ],
            ), // Row
            const SizedBox(height: APPSizes.spaceBtwSections),

            /// Sign In Action
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text("Sign In"))),
            const SizedBox(height: APPSizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () => Get.to(() => const SignupScreen()), child: const Text("createAccount"))),
          ], // Column children
        ), // Column
      ), // Padding
    );
  } // build
}
