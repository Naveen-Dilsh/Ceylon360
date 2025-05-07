import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/login/login_controller.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';

class APPLoginForm extends StatelessWidget {
  const APPLoginForm({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: APPSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: (value) => APPValidator.validateEmail(value),
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: "Email"),
            ), // TextFormField
            const SizedBox(height: APPSizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => APPValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  children: [
                    Obx(() => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)),
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
            SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: const Text("signIn"))),
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
