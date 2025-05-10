import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../../utils/constants/colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: APPSizes.spaceBtwSections),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Sign In",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: APPColors.primary,
                  ),
            ),

            const SizedBox(height: APPSizes.spaceBtwItems),

            /// Email
            TextFormField(
              controller: controller.email,
              validator: (value) => APPValidator.validateEmail(value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.direct_right, color: APPColors.primary),
                labelText: "Email",
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: APPColors.primary.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: APPColors.primary.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: APPColors.primary,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: isDark ? APPColors.dark.withOpacity(0.5) : APPColors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => APPValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  prefixIcon: const Icon(
                    Icons.password_outlined,
                    color: APPColors.primary,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                      color: APPColors.secondary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: APPColors.primary.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: APPColors.primary.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: APPColors.primary,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: isDark ? APPColors.dark.withOpacity(0.5) : APPColors.white.withOpacity(0.8),
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
                        activeColor: APPColors.primary,
                        onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)),
                    Text("Remember me",
                        style: TextStyle(
                          color: isDark ? APPColors.textWhite.withOpacity(0.7) : APPColors.textPrimary,
                        )),
                  ],
                ),

                /// Forget Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgotPassword()),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: APPColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: APPSizes.spaceBtwSections),

            /// Sign In Action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: APPColors.buttonPrimary,
                  foregroundColor: APPColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: APPSizes.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: APPColors.primary.withOpacity(0.5),
                ),
                child: Text(
                  "Start Exploring",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: APPColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            const SizedBox(height: APPSizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: APPColors.secondary,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: APPSizes.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Create Account",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: APPColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
