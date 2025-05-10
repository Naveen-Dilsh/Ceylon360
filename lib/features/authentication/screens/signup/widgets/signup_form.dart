import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';
import 'terms_condition_checkbox.dart';

class APPSignUpForm extends StatelessWidget {
  const APPSignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final isDark = APPHelperFunctions.isDarkMode(context);

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          // Form Fields Container
          Container(
            decoration: BoxDecoration(
              color: isDark ? APPColors.darkContainer.withOpacity(0.5) : APPColors.white.withOpacity(0.8),
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
            padding: const EdgeInsets.all(APPSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                Text(
                  "Personal Information",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark ? APPColors.white : APPColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: APPSizes.sm),

                // First & Last Name
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.firstName,
                        validator: (value) => APPValidator.validateEmptyText('First name', value),
                        expands: false,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          prefixIcon: Icon(Iconsax.user, color: APPColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                            borderSide: BorderSide(color: APPColors.borderPrimary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                            borderSide: BorderSide(color: APPColors.borderSecondary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                            borderSide: BorderSide(color: APPColors.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: isDark ? APPColors.darkContainer : APPColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: APPSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.lastName,
                        validator: (value) => APPValidator.validateEmptyText('Last name', value),
                        expands: false,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          prefixIcon: Icon(Iconsax.user_add, color: APPColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                            borderSide: BorderSide(color: APPColors.borderPrimary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                            borderSide: BorderSide(color: APPColors.borderSecondary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                            borderSide: BorderSide(color: APPColors.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: isDark ? APPColors.darkContainer : APPColors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: APPSizes.spaceBtwSections),

                // Account Information Section
                Text(
                  "Account Details",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark ? APPColors.white : APPColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: APPSizes.sm),

                // Username
                TextFormField(
                  controller: controller.username,
                  validator: (value) => APPValidator.validateEmptyText('Username', value),
                  expands: false,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Create a unique username",
                    prefixIcon: Icon(Iconsax.user_octagon, color: APPColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.borderPrimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.borderSecondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: isDark ? APPColors.darkContainer : APPColors.white,
                  ),
                ),
                const SizedBox(height: APPSizes.spaceBtwInputFields),

                // Email
                TextFormField(
                  controller: controller.email,
                  validator: (value) => APPValidator.validateEmail(value),
                  expands: false,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email address",
                    prefixIcon: Icon(Iconsax.direct, color: APPColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.borderPrimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.borderSecondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: isDark ? APPColors.darkContainer : APPColors.white,
                  ),
                ),
                const SizedBox(height: APPSizes.spaceBtwInputFields),

                // Phone Number
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: (value) => APPValidator.validatePhoneNumber(value),
                  expands: false,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    hintText: "Enter your contact number",
                    prefixIcon: Icon(Iconsax.call, color: APPColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.borderPrimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.borderSecondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                      borderSide: BorderSide(color: APPColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: isDark ? APPColors.darkContainer : APPColors.white,
                  ),
                ),

                const SizedBox(height: APPSizes.spaceBtwSections),

                // Security Section
                Text(
                  "Security",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark ? APPColors.white : APPColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: APPSizes.sm),

                // Password
                Obx(
                  () => TextFormField(
                    controller: controller.password,
                    validator: (value) => APPValidator.validatePassword(value),
                    obscureText: controller.hidePassword.value,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Create a secure password",
                      prefixIcon: Icon(Iconsax.password_check, color: APPColors.primary),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                        icon: Icon(
                          controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                          color: APPColors.darkGrey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                        borderSide: BorderSide(color: APPColors.borderPrimary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                        borderSide: BorderSide(color: APPColors.borderSecondary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                        borderSide: BorderSide(color: APPColors.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: isDark ? APPColors.darkContainer : APPColors.white,
                    ),
                  ),
                ),

                // Password Strength Indicator
                const SizedBox(height: APPSizes.xs),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: APPColors.primary.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: APPColors.primary.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: APPColors.primary.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: APPColors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: APPSizes.xs),
                Text(
                  "Strong password",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? APPColors.white.withOpacity(0.7) : APPColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: APPSizes.spaceBtwSections),

          // Terms & Conditions Checkbox
          const APPTermsAndConditionCheckbox(),

          const SizedBox(height: APPSizes.spaceBtwSections),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              style: ElevatedButton.styleFrom(
                backgroundColor: APPColors.primary,
                foregroundColor: APPColors.white,
                elevation: 5,
                padding: const EdgeInsets.symmetric(vertical: APPSizes.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(APPSizes.buttonRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.user_add),
                  const SizedBox(width: APPSizes.sm),
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: APPColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
